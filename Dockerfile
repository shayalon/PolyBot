FROM python:3.8.15-slim-buster

WORKDIR /app/

COPY . /app

RUN pip install --upgrade pip \
    && pip install -r requirements.txt

CMD ["python3", "bot.py"]