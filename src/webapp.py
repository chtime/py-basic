#!/usr/bin/env python3

from flask import Flask

flask_app = Flask(__name__)

@flask_app.route("/")
def hello_world():
    return {"content": "hello, world!"}

