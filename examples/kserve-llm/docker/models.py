# Copyright 2023, SAP SE or an SAP affiliate company and KServe contributors

import os

from transformers import AutoTokenizer, pipeline, logging, AutoModelForCausalLM
from auto_gptq import AutoGPTQForCausalLM, BaseQuantizeConfig
import torch
import os
from flask import Flask, request
import logging
from signal import signal, SIGINT

app = Flask(__name__)
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s %(levelname)s %(name)s %(threadName)s : %(message)s')

model, tokenizer, model_prompt_template = None, None, None

MODEL_URL = os.environ.get('MODEL_URL', '/mnt/models')
MODEL_NAME = os.environ.get('MODEL_NAME', 'custom')
GPU_ENABLED = os.environ.get('GPU_ENABLED', 'False') == 'True'


def handler(signal_received, frame):
    # SIGINT or  ctrl-C detected, exit without error
    exit(0)


def check_gpu():
    app.logger.info(f"CUDA is avaiable: {torch.cuda.is_available()}")

    # setting device on GPU if available, else CPU
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    app.logger.info(f'Using device: {device}')

    # additional Info when using cuda
    if device.type == 'cuda':
        gpu_count = torch.cuda.device_count()
        app.logger.info(f"Device Count: {gpu_count}")
        for i in range(gpu_count):
            app.logger.info(f"Device ID: {i}")
            app.logger.info(f"Device Name: {torch.cuda.get_device_name(i)}")
            app.logger.info('Memory Usage:')
            app.logger.info(f'Allocated: {round(torch.cuda.memory_allocated(i)/1024**3,1)} GB')
            app.logger.info(f'Cached: {round(torch.cuda.memory_reserved(i)/1024**3,1)} GB')
    return device.type
# check if the file prompt_template.txt exists in the model path
# if it does, use it as the prompt template and return it
def get_prompt_template(model_path):
    prompt_template_path = os.path.join(model_path, "prompt_template.txt")
    if os.path.exists(prompt_template_path):
        app.logger.info(f"Found prompt template at {prompt_template_path}")
        with open(prompt_template_path, "r") as f:
            return f.read()
    else:
        return None

@app.before_first_request
def init():

    device = ("cuda" if ( (check_gpu() == 'cuda') and GPU_ENABLED) else "cpu")
    
    global model, tokenizer, model_prompt_template
    if model is None or tokenizer is None:
        app.logger.info(f"Loading Model from {MODEL_URL}")

        model_basename = "model"

        model_prompt_template = get_prompt_template(MODEL_URL)

        use_triton = False

        tokenizer = AutoTokenizer.from_pretrained(MODEL_URL, use_fast=True)

        model = AutoModelForCausalLM.from_pretrained(MODEL_URL,
                torch_dtype=torch.float16,
                device_map="auto",
                # device=("cuda:0" if device == 'cuda' else "cpu"),
                revision="main",
                )
        app.logger.info("Model loaded successfully")




@app.route("/v1/models/{}:predict".format(MODEL_NAME), methods=["POST"])
def predict():
    """
    Perform an inference on the model created in initialize

    Returns:
        String response of the prompt for the given test data
    """
    global model, tokenizer, model_prompt_template
    input_data = dict(request.json)

    if "prompt" not in input_data:
        return "Prompt not found", 400
    prompt = input_data["prompt"]
    # if model prompt template  is in input data, use it
    # else if model prompt template is in model path, use it
    # else use default
    system_message = ""
    if "prompt_template" in input_data:
        prompt_template = input_data["prompt_template"]
        app.logger.info(f"Prompt template from input data: {prompt_template}")
    elif model_prompt_template is not None:
        prompt_template = model_prompt_template
    else:
        prompt_template='[INST] <<SYS>> {system_message} <</SYS>> {prompt} [/INST]'
        system_message = "You are a helpful, respectful and honest assistant. Always answer as helpfully as possible, while being safe.  Your answers should not include any harmful, unethical, racist, sexist, toxic, dangerous, or illegal content. Please ensure that your responses are socially unbiased and positive in nature. If a question does not make any sense, or is not factually coherent, explain why instead of answering something not correct. If you don't know the answer to a question, please don't share false information."

    prompt_template = prompt_template.format(system_message=system_message, prompt=prompt)
    app.logger.info(f"Prompt template: {prompt_template}")
    result_length = input_data.get("result_length", 100)

    pipe = pipeline(
    "text-generation",
    model=model,
    tokenizer=tokenizer,
    max_new_tokens= min(512, result_length),
    temperature=0.7,
    top_p=0.95,
    repetition_penalty=1.15
    )

    result = pipe(prompt_template)[0]['generated_text']

    output = {"result": "".join(result)}
    return output


if __name__ == "__main__":
    signal(SIGINT, handler)
    app.run(host="0.0.0.0", debug=True, port=8080)
