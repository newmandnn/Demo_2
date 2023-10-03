from flask import Flask, render_template
import random

app = Flask(__name__)


images = [
    
    "https://raygun.com/blog/images/best-devops-tools/feature-23.jpg"
]

@app.route('/')
def index():
    url = random.choice(images)
    return render_template('index.html', url=url)

if __name__ == "__main__":
    app.run(host="0.0.0.0")
