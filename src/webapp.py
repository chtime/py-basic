#!/usr/bin/env python3

import logging
import socket

from flask import Flask

logger = logging.getLogger(__name__)
flask_app = Flask(__name__)


@flask_app.route("/")
def hello_world():
    """Hello World!"""
    try:
        hostname = socket.gethostname()
    except Exception as e:
        logger.warning(e)
        hostname = "n/a"

    return {"content": "hello, world!", "host": hostname}
