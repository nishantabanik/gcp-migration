# Mock Developer Self-Service
This is a simple Python web application leveraging [Flask](https://flask.palletsprojects.com/en/3.0.x/) and [HTMX](https://htmx.org/) along with [Bootstrap](https://getbootstrap.com/).
It mocks a potential developer self-service site that enables developers to provision cloud infrastructure.

## Prerequisites
- Python 3.12+

## Installation
Use pip to install the required packages as documented in the `requirements.txt` file.

## Containerized

Building the image:
```bash
podman build -t developer-self-service .
```

Running the image:
```bash
podman run -d -p 5000:5000 developer-self-service:latest
```

The mocked service can then be accessed at localhost:5000