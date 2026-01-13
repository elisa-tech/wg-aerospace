# Environment building notes

## Development

- Make sure to lint `docker run --rm -i hadolint/hadolint < Dockerfile`
- If storage gets full, prune the Docker system `docker system prune -f -a`

### ARM

- Used a ARM64 host from AWS and Ubuntu 24.x

