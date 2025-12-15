# Copyright 2023, SAP SE or an SAP affiliate company and KServe contributors
import logging
from signal import signal, SIGINT
import argparse
from apps import create_aps


logging.basicConfig(level=logging.DEBUG, format='%(asctime)s %(levelname)s %(name)s %(threadName)s : %(message)s')
parser = argparse.ArgumentParser()
parser.add_argument(
    "--api_url", type=str,
    help="The URL of the llava api served by textgen webui", required=True
)
args, _ = parser.parse_known_args()
app = create_aps(args.api_url)

def handler(signal_received, frame):
    # SIGINT or  ctrl-C detected, exit without error
    exit(0)

if __name__ == "__main__":
  signal(SIGINT, handler)
  app.run(host="0.0.0.0", debug=True, port=8080)








    
    
   
