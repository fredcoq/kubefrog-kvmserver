from flask import Flask, request, jsonify
from signal import signal, SIGINT
import json
app = Flask(__name__)
def handler(signal_received, frame):
    # SIGINT or  ctrl-C detected, exit without error
    exit(0)
# This is a mock function that simulates a completion

@app.route('/api/v1/completions', methods=['POST'])
def completions():
    data = request.json
    print(data)
    if not data or 'prompt' not in data or 'max_tokens' not in data or 'stop' not in data:
        return jsonify({'error': 'Missing required parameters'}), 400

    response = {
        'id': 'mock-id',
        'object': 'text_completion',
        'created': 1643723904,
        'model': 'mock-model',
        "usage": {
                "prompt_tokens": 8,
                "total_tokens": 8
            },
        'choices': [
            {
                'text': 'toto',
                'index': 0,
                'logprobs': None,
                'finish_reason': 'stop'
            }
        ]
    }

    return jsonify(response)

if __name__ == '__main__':
    signal(SIGINT, handler)
    app.run(host='0.0.0.0', port=5099, debug=True)