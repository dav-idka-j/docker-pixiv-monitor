FROM python:3-slim

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Create a non-root user and group with a static UID/GID for predictable permissions.
RUN addgroup --gid 1001 appuser && adduser --uid 1001 --ingroup appuser --system --no-create-home appuser

WORKDIR /app

RUN git clone https://github.com/moltony/pixiv-monitor.git .

RUN pip install --no-cache-dir -r requirements.txt

COPY start.sh .

RUN chmod +x ./start.sh

RUN chown -R appuser:appuser /app

USER appuser

CMD ["./start.sh"]
