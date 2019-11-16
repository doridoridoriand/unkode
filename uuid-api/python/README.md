# UUID API Python
## Requirements
- Python >= 3.6 (Reccomend >= 3.7)
- pipenv

## Installation
- pipenv run

## Run
Standalone
```
$ python app.py
```

with Gunicron
```
$ gunicorn -k uvicorn.workers.UvicornWorker app:api
```
