# pixiv-monitor via Docker Compose

This repository provides a Docker Compose setup to run [pixiv-monitor](https://github.com/moltony/pixiv-monitor).

This setup includes a simple web server to make the generated RSS feed directly accessible.

## Prerequisites

- Docker (or podman)
- Docker Compose (or podman compose)

## Setup

1. **Configure Settings:**
    Create a `settings.json` file in this directory. You can use the following template. **You must add the Pixiv `artist_ids` you wish to monitor.**

    ```json
    {
        "artist_ids": [
            123456,
            789012
        ],
        "check_interval": 3600,
        "notifications_off": true,
        "log": {
            "backup_count": 5,
            "max_size": 10,
            "directory": "log",
            "level": "info"
        }
    }
    ```

2. **Set Up Environment:**
    Create a `.env` file in this directory with your Pixiv Refresh Token.

    ```bash
    REFRESH_TOKEN0='your-pixiv-refresh-token-here'
    ```
    You can find instructions on how to get this token in the [PixivFe documentation](https://pixivfe-docs.pages.dev/hosting/api-authentication/).

3. **Prepare Data Directories (Important Security Step):**
    This container runs as a non-root user (`uid=1001`) for security. You must create the data persistence directories on your host machine and give this user ownership **before** starting the container.

    Run the following commands:
    ```bash
    mkdir -p ./data/logs
    touch ./data/seen.json
    sudo chown -R 1001:1001 ./data # For docker
    podman unshare chown 1001:1001 -R data/ # For podman
    ```
    This ensures the container has permission to write to the log directory and the `seen.json` database.

    Add the following to `./data/seen.json`
    ```json
    {
        "illusts": []
    }
    ```

## Usage

- **Build and Start:**
    To build the Docker image and start the service in detached mode, run:
    ```bash
    docker-compose up -d --build
    ```

  To re-build with the newest changes from upstream
  ```bash
  docker compose up -d --build --no-cache
  ```

- **View Logs:**
    To follow the logs from the monitor, run:
    ```bash
    docker-compose logs -f
    ```

- **Access the RSS Feed:**
    Once the container is running, the RSS feed will be available in your browser or RSS reader at:
    **`http://localhost:8000/pixiv.atom`**

- **Stop the Service:**
    To stop the service, run:
    ```bash
    docker-compose down
    ```

## Data Persistence

- **Logs:** Logs are stored in the `./data/logs/` directory.
- **Seen History:** The database of seen illustrations is stored in `./data/seen.json`.
