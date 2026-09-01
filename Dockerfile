FROM python:alpine
WORKDIR /app
COPY app.py .
RUN pip3 install boto3 flask flask_cors
CMD ["python3", "app.py"]
