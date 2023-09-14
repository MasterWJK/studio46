from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Handle CORS


# hello wonderful world
@app.route("/")
def hello_app():
    return "Hello World"


isUnlocked = False  # Initialize the boolean variable


@app.route("/lock", methods=["POST"])
def lock():
    global isUnlocked
    isUnlocked = False
    return jsonify({"status": "Locked", "isUnlocked": isUnlocked})


@app.route("/unlock", methods=["POST"])
def unlock():
    global isUnlocked
    isUnlocked = True
    return jsonify({"status": "Unlocked", "isUnlocked": isUnlocked})


# access the website
@app.route("/status", methods=["GET"])
def status():
    global isUnlocked
    return jsonify(
        {"status": "Unlocked" if isUnlocked else "Locked", "isUnlocked": isUnlocked}
    )


# if __name__ == "__main__":
#     app.run(host="192.168.1.2", port=8080)
