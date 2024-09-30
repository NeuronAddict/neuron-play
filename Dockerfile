# https://hub.docker.com/r/nvidia/cuda/tags?page=&page_size=&ordering=&name=12.4
FROM docker.io/nvidia/cuda:12.4.1-runtime-ubuntu22.04 AS python-base

ENV VIRTUAL_ENV=/app/venv

RUN apt update && apt install --no-install-recommends -y \
      python3.11-minimal \
      python3.11-venv \
    && python3.11 -m venv $VIRTUAL_ENV

ENV PATH="$VIRTUAL_ENV/bin:$PATH"
WORKDIR /app



FROM python-base AS install

COPY requirements.txt .
RUN pip install -r requirements.txt



FROM python-base

COPY --from=install "${VIRTUAL_ENV}" "${VIRTUAL_ENV}"

ARG ADD_PACKAGES

RUN if [[ ! -z "$ADD_PACKAGES" ]]; then apt update && apt install -y --no-install-recommends $ADD_PACKAGES; fi

COPY app.py .

USER 1234

ENTRYPOINT ["python"]
