from flask import Flask, render_template, request
import threading
import time
import logging

app = Flask(__name__)

# Create a logger instance
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

# Configure the logger to write to a file
file_handler = logging.FileHandler('requests.log')
file_handler.setFormatter(logging.Formatter('%(asctime)s - [%(threadName)s] - %(message)s'))
logger.addHandler(file_handler)

# Configure the logger to write to stdout
stdout_handler = logging.StreamHandler()
stdout_handler.setFormatter(logging.Formatter('%(asctime)s - [%(threadName)s] - %(message)s'))
logger.addHandler(stdout_handler)


# Function to simulate a time-consuming task
def log_request_and_measure_speed(ip, url):
    thread_name = threading.currentThread().name
    start_time = time.time()
    log_message = f"{time.strftime('%Y-%m-%d %H:%M:%S')} - [Thread {thread_name}] - {ip} - {url}\n"
    
    # Log the request using the logger
    logger.info(log_message)
    
    end_time = time.time()
    write_speed = end_time - start_time

    return log_message, write_speed


@app.route('/')
def index():
    with open('requests.log', 'r') as log_file:
        log_entries = log_file.readlines()
    return render_template('index.html', log_entries=log_entries)

@app.route('/log_request')
def log_request():
    # Get client IP and URL from the request context
    client_ip = request.remote_addr
    request_url = request.url
    
    # Start a new thread to log the request and measure the write speed
    log_thread = threading.Thread(target=log_request_and_measure_speed, args=(client_ip, request_url))
    log_thread.start()
    
    return "Request logging in progress..."

if __name__ == '__main__':
    app.run(debug=True,port=5000)
