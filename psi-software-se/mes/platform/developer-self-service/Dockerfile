FROM python:3.12-alpine3.20

WORKDIR /python-docker

COPY static static
COPY templates templates
COPY app.py app.py
COPY requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

CMD [ "python3", "-m", "flask", "run", "--host=0.0.0.0" ]