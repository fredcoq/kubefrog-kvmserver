FROM pytorch/pytorch:2.0.0-cuda11.7-cudnn8-runtime

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    &&  apt-get -yq install --no-install-recommends git
COPY requirements.txt ./requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt 
RUN pip3 uninstall -y transformers && pip3 install git+https://github.com/huggingface/transformers.git
RUN GITHUB_ACTIONS=true pip3 install auto-gptq

COPY models.py /app/models.py
ENV PYTHONPATH=/app/
WORKDIR /app

ENV MODEL_URL="/mnt/models" \
    GPU_ENABLED="False" \
    MODEL_NAME="model"

ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/cuda-11.7/targets/x86_64-linux/lib"

CMD python models.py --model_name $MODEL_NAME