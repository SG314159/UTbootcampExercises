from flask import Flask
app = Flask(__name__)  # creates new Flask app instance

#Create Flask routes
@app.route("/")
def hello_world():
    return 'hello world from app.py'


