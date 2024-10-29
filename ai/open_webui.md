# Open WebUI

## Install Open WebUI

- [Open WebUI](https://openwebui.com/)
- [open-webui/open-webui: User-friendly AI Interface](https://github.com/open-webui/open-webui)

1. Download and install [Ollama](https://ollama.com/).
2. Run a model in `ollama`

```sh
ollama run llama3.2
```

3. Run Open WebUI with Nvidia GPU support

```sh
docker run -d -p 3000:8080 --gpus all --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:cuda
```

4. Navigate to http://localhost:3000/
5. First time, you will need to create an account

## Upgrade Open WebUI

```sh
docker container stop open-webui
docker container rm open-webui
docker pull ghcr.io/open-webui/open-webui:cuda

docker run -d -p 3000:8080 --gpus all --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:cuda
```
