#!/usr/bin/env python
import requests

class WebHooks():
    options = { 'headers' : {"Content-Type":"application/json"} }
    def __init__(self, **kwargs):
        self.options.update(kwargs)

    def set_hookurl(self, hookurl):
        self.options['hookurl'] = hookurl

    def set_payload(self, payload):
        self.options['payload'] = payload

    def send_message(self, **kwargs):
        self.options.update(kwargs)
	return requests.post(
            self.options['hookurl'],
            json=self.options['payload'],
            headers=self.options['headers']
        )
    
