import unittest
from apps import create_app
import requests
import json
import logging

logging.basicConfig(level=logging.DEBUG, format='%(asctime)s %(levelname)s %(name)s %(threadName)s : %(message)s')
class TestAPIProxyLLaVA(unittest.TestCase):

    def setUp(self):
        self.app = create_app(url= "http://127.0.0.1:5099", name=__name__)

    def test_create_app(self):
        self.assertIsInstance(self.app, object)

    def test_embeddings(self):
        # Test with valid data
        json_data = {"text": "This is a test string"}
        response = self.app.test_client().post('/v1/embeddings', json=json_data)
        self.assertEqual(response.status_code, 200)
        response_json = json.loads(response.data)
        self.assertIn('object', response_json)
        self.assertIn('data', response_json)
        self.assertIn('model', response_json)
        self.assertIn('usage', response_json)

        # Test with invalid data
        json_data = {"wrong_key": "This is a test string"}
        response = self.app.test_client().post('/v1/embeddings', json=json_data)
        self.assertEqual(response.status_code, 200)
        response_json = json.loads(response.data)
        self.assertIn('object', response_json)
        self.assertIn('data', response_json)
        self.assertIn('model', response_json)
        self.assertIn('usage', response_json)

    def test_predict(self):
        # Test with valid data
        data = """{ "model": "llava-v1.5-7b",
                    "messages": 
                          [{
                            "role": "user", 
                            "content": [
                                 {"text": "This is a test string", 
                                 "image_url": {"url": "https://example.com/image.jpg"}
                                 }
                                 ]
                            }
                        ]
                        }"""
        json_data = json.loads(data)
        response = self.app.test_client().post('/v1/chat/completions', json=json_data)
        self.assertEqual(response.status_code, 200)
        response_json = json.loads(response.data)
        logging.info(f'Response: {response_json}')
        self.assertIn('id', response_json)
        self.assertIn('object', response_json)
        self.assertIn('created', response_json)
        self.assertIn('model', response_json)
        self.assertIn('system_fingerprint', response_json)
        self.assertIn('choices', response_json)
        self.assertIn('usage', response_json)

        # Test with invalid data
        json_data = {"wrong_key": "This is a test string"}
        response = self.app.test_client().post('/v1/chat/completions', json=json_data)
        self.assertEqual(response.status_code, 400)


    def test_predict_no_messages(self):
        json_data = {"messages": []}
        response = self.app.test_client().post('/v1/chat/completions', json=json_data)
        self.assertEqual(response.status_code, 400)


    def test_predict_no_content(self):
        json_data = {"messages": [{"content": []}]}
        response = self.app.test_client().post('/v1/chat/completions', json=json_data)
        self.assertEqual(response.status_code, 400)


if __name__ == '__main__':
    unittest.main()