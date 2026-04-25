from flask import Flask, jsonify
import time

app = Flask(__name__)
start_time = time.time()

@app.route('/')
def home():
    return jsonify({
        "app": "DevOps Monitoring App",
        "status": "running",
        "version": "1.0",
        "uptime_seconds": int(time.time() - start_time)
    })

@app.route('/health')
def health():
    return jsonify({"status": "healthy"}), 200

@app.route('/metrics')
def metrics():
    return jsonify({
        "uptime": int(time.time() - start_time),
        "status": "up"
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
