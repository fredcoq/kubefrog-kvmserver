# Copyright 2023, SAP SE or an SAP affiliate company and KServe contributors

import os
from flask import Flask, request
import logging
from signal import signal, SIGINT
import requests
import logging

from pydantic import BaseModel, ValidationError, field_validator
from typing import Optional, List, Any

class Messages(BaseModel):
    '''Messages model that reflets the messages field of the /v1/chat/completions endpoint'''
    role: str
    content: List[dict]
class Query(BaseModel):
    '''Query model that reflets the request body of the /v1/chat/completions endpoint'''
    model: str
    messages: List[Messages]
    temperature: Optional[float] = None
    top_p: Optional[float] = None
    n: Optional[int] = None
    stream: Optional[bool] = None
    stop: Optional[List[str]] = None
    max_tokens: Optional[int] = None
    presence_penalty: Optional[float] = None
    frequency_penalty: Optional[float] = None
    logit_bias: Optional[dict] = None
    user: Optional[str] = None




logging.basicConfig(level=logging.DEBUG, format='%(asctime)s %(levelname)s %(name)s %(threadName)s : %(message)s')
MODEL_URL = ""

def create_app(url=None, name=None):

    app = Flask(name)


    # check if the file prompt_template.txt exists in the model path
    # if it does, use it as the prompt template and return it
    @app.route("/v1/embeddings", methods=["POST"])
    def embeddings():
        '''
        get a text string
        return emdeddings values
        '''
        json_data = request.get_json()
        logging.info(f'Using prompt: {json_data}')
        response_json = {
            "object": "list",
            "data": [
                {
                "object": "embedding",
                "embedding": [-0.0028842222]*512,
                "index": 0
                }
            ],
            "model": "text-embedding-ada-002",
            "usage": {
                "prompt_tokens": 8,
                "total_tokens": 8
            }
            }
        return response_json
    @app.route("/v1/chat/completions", methods=["POST"])
    def predict():

        logging.info(f'Got requesst')
        # get the json data
        query = request.get_json()
        print(query)
        try:
            Query.model_validate(query)
        except ValidationError as e:
            logging.error(f'Validation error: {e}')
            return {"error": str(e)}, 400
        
        # get the query
        prompt = query['messages'][0]['content'][0]['text']

        # get the image
        img_str = query['messages'][0]['content'][0]['image_url']['url']
        # build the prompt
        CONTEXT = "You are LLaVA, a large language and vision assistant trained by UW Madison WAIV Lab. You are able to understand the visual content that the user provides, and assist the user with a variety of tasks using natural language. Follow the instructions carefully and explain your answers in detail.### Human: Hi!### Assistant: Hi there! How can I help you today?\n"
        prompt = CONTEXT + f'### Human: {prompt}  \n<img src="{img_str}">### Assistant: '
        logging.info(f'Using prompt: {prompt}')
        # build the json for the model
        json={'prompt': prompt, 'max_tokens': 200, 'stop': ['\n###']}
        # get the response from the model
       
        response = requests.post(url+'/api/v1/completions', json=json)
        # get the text from the response
        text = response.json()['choices'][0]['text']
        id = response.json()['id']
        object_ = response.json()['object']
        created = response.json()['created']
        model = response.json()['model']
        choices = response.json()['choices']
        usage = response.json()['usage']


        response_json = {'id': id,
                        'object': object_,
                        'created': created,
                        'model': model,
                        'system_fingerprint': 'fp_44709d6fcb',
                        'choices': [{'index': 0,
                                    'message': {'role': 'assistant',
                                                'content': text},
                                    'finish_reason': choices[0]['finish_reason']}],
                        'usage': usage}
        
        # return the response json
        return response_json
    return app





    
    
   
