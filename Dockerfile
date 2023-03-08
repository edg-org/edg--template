ARG PYTHON_TAG=3.9
ARG GH_USER=soulbah
ARG GH_REPO=REPO

FROM python:${PYTHON_TAG} AS builder

RUN pip install --user pipenv

ENV PIPENV_VENV_IN_PROJECT=1

ADD Pipfile.lock Pipfile /app/

WORKDIR /app

RUN /root/.local/bin/pipenv install --system --deploy --ignore-pipfile

FROM tiangolo/uvicorn-gunicorn-fastapi:python${PYTHON_TAG}-slim

LABEL org.opencontainers.image.source=https://github.com/${GH_USER}/${GH_REPO}

RUN apt-get update && apt-get install -y default-libmysqlclient-dev \
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

COPY api /app/