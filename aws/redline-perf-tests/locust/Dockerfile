FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /mnt/locust

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir "locust>=2,<3" "python-dotenv>=1,<2" \
    && adduser --disabled-password --gecos "" locust

COPY --chown=locust:locust locust_throughput.py locust.conf scaling_api.py ./

USER locust

EXPOSE 8089 5557 5558

ENTRYPOINT ["locust"]