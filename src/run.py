#!/usr/bin/env python3

from app import flask_app

if __name__ == "__main__":
    flask_app.run(debug=True, port=8000)
