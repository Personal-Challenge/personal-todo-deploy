# personal-todo-deploy

Repositorio de despliegue para levantar la aplicación Personal Todo con Docker Compose.

## Requisitos

- Git
- Docker
- Docker Compose v2 disponible como `docker compose`

## Uso

1. Clonar este repositorio:

   ```sh
   git clone https://github.com/Personal-Challenge/personal-todo-deploy.git
   cd personal-todo-deploy
   ```

2. Ejecutar el setup:

   ```sh
   make setup
   ```

   El script clona desde la rama `main`:

   - `https://github.com/Personal-Challenge/personal-todo-backend.git` en `backend/`
   - `https://github.com/Personal-Challenge/personal-todo-frontend.git` en `frontend/`

3. Revisar variables de entorno:

   ``make setup` crea `.env` automáticamente si no existe. Revisar ese archivo antes de levantar la aplicación.

4. Levantar la aplicacion:

   ```sh
   make up
   ```

   Asegurate de tener Docker corriendo antes de ejecutar el comando. Por defecto:

   - Backend: `http://localhost:8080`
   - Frontend: `http://localhost:3000`

5. Datos de ejemplo:

   Para cargar tareas de ejemplo, usar:

   ```sh
   make seed
   ```

   O levantar la aplicación e importar datos en un solo paso con:

   ```sh
   make up-seed
   ```

6. Bajar los contenedores con `make down`.

## Comandos

Referencia de comandos disponibles:

| Comando | Descripción |
| --- | --- |
| `make setup` | Clona o actualiza `backend/` y `frontend/`. |
| `make up` | Levanta la aplicación con build. |
| `make up-detached` | Levanta la aplicación en segundo plano con build. |
| `make up-seed` | Levanta la aplicación en segundo plano e importa datos de ejemplo. |
| `make build` | Construye las imagenes Docker. |
| `make down` | Baja los contenedores. |
| `make restart` | Baja y vuelve a levantar la aplicacion. |
| `make logs` | Muestra logs de todos los servicios. |
| `make ps` | Muestra el estado de los contenedores. |
| `make pull` | Actualiza backend y frontend ejecutando `setup.sh`. |
| `make seed` | Importa tareas de ejemplo desde `seeds/tasks.json`. |
| `make clean` | Baja contenedores y elimina volumenes. |

Los comandos anteriores son wrappers sobre Docker Compose y el script `setup.sh`.

## Variables de entorno

El archivo base es `.env.example`. Para trabajar localmente, copiarlo a `.env`:

```sh
cp .env.example .env
```

Variables disponibles:

| Variable | Valor por defecto | Uso |
| --- | --- | --- |
| `BACKEND_PORT` | `8080` | Puerto publicado para la API. |
| `FRONTEND_PORT` | `3000` | Puerto publicado para la aplicacion web. |
| `NODE_ENV` | `production` | Entorno usado por los contenedores de aplicacion. |
| `MONGO_URI` | `mongodb://admin:admin123@mongo:27017/todoapp?authSource=admin` | Conexión del backend a MongoDB dentro de la red Docker. |
| `VITE_API_URL` | `http://localhost:8080` | URL pública de la API que usa el navegador. |
| `VITE_TASKS_ENDPOINT` | `/tasks` | Endpoint base de tareas usado por el frontend. |

Detalles importantes:

- `MONGO_URI` usa el hostname Docker `mongo` porque el backend corre dentro de la red de Compose.
- `VITE_API_URL` apunta a `localhost:8080` porque el navegador llama a la API desde la máquina host.
- Las variables `VITE_*` se usan durante el build del frontend. Si las cambias, reconstruir la imagen con `make up`.

## Servicios

Docker Compose levanta tres servicios:

- `mongo`: MongoDB disponible desde la máquina host en `localhost:27017`.
- `backend`: API disponible en `http://localhost:8080`.
- `frontend`: aplicación web disponible en `http://localhost:3000`.

Para conectarte a MongoDB desde la máquina host, usa:

```sh
mongosh "mongodb://admin:admin123@localhost:27017/todoapp?authSource=admin"
```

Los datos de MongoDB se persisten en el volumen Docker `mongo_data`.

## Datos de ejemplo

El archivo `seeds/tasks.json` contiene tareas para probar la aplicacion. La carga se ejecuta con `make seed`; también se puede usar `make up-seed` para levantar los servicios e importar los datos en un solo paso.

La importación usa `mongoimport` dentro del contenedor `mongo`, importa sobre la colección `tasks` de la base `todoapp` y reemplaza los datos existentes de esa coleccion.

Usalo como carga inicial o para reiniciar los datos locales de tareas.

## Actualizar backend y frontend

Para traer los últimos cambios de la rama `main` en ambos repositorios, usar `make pull`. Si `backend/` o `frontend/` ya existen, el script cambia a la rama `main` y ejecuta `git pull origin main`.

Luego reconstruir y levantar con `make up`.

## Estructura

```text
personal-todo-deploy/
|-- docker-compose.yml
|-- Makefile
|-- .env.example
|-- .gitignore
|-- setup.sh
|-- README.md
|-- seeds/
|   `-- tasks.json
|-- backend/   # generado por setup.sh, no versionado
`-- frontend/  # generado por setup.sh, no versionado
```
