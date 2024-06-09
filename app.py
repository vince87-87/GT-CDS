from flask import Flask
import redis
import os

app = Flask(__name__)

# Read Redis host and port from environment variables with default values
redis_host = os.getenv('REDIS_HOST')
if not redis_host:
    raise ValueError("The REDIS_HOST environment variable is not set.")

redis_port = int(os.getenv('REDIS_PORT', 6379))

# Initialize Redis connection
r = redis.Redis(host=redis_host, port=redis_port)

@app.route('/')
def index():
    count = r.incr('counter')
    return f'This is the {count} visitor'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)