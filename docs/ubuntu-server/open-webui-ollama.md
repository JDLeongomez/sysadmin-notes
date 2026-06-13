# Open WebUI & Ollama

---

## Open WebUI

```bash
# Levantar / actualizar desde Docker Compose
cd ~/open-webui
docker compose pull
docker compose up -d

# Verificar que está corriendo
docker ps
```

---

## Ollama

```bash
# Actualizar Ollama
curl -fsSL https://ollama.com/install.sh | sh
sudo systemctl restart ollama
systemctl status ollama --no-pager
ollama --version

# Actualizar todos los modelos instalados
ollama list \
  | awk 'NR>1 && $1!="" {print $1}' \
  | sort -u \
  | xargs -r -n1 -P2 ollama pull
```
