FROM python:2.7-alpine

RUN pip install requests

COPY test.py .
RUN chmod +x test.py

ENTRYPOINT [ "./test.py" ]