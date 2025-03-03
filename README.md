# nginx

This nginx repository was created to support Victoria Bros. ever growing services, which allows us to store Nginx server conf. file close to the service and dynamically to them dynamically load them into the running nginx instance.


## Structure

- docker - includes Dockerfile.nginx for building and running nginx and its configurations
- nginx/ssl - includes dhparam and options-ssl files that will be loaded by nginx/conf.d/ssl.conf
- nginx/data - includes data for the example domains
- nginx/conf.d - includes service and necessary configuration files that is loaded by nginx
- nginx/conf.d/base.conf - includes generic nginx configuration
- nginx/conf.d/ssl.conf - add or replace ssl related nginx configuration


## Configuration

## Build

Replace the placeholder `<replace_with_github_token>` in file `docker/.env.docker` with a [fine-grained token from GitHub](https://github.com/settings/tokens) with lifetime less than 366days, selected repositories and permissions:

- Contents as **Read-Only**

```bash
$ cat docker/.env.docker | xargs printf -- '--build-arg %s\n' | xargs docker build -t victoriabros/nginx -f docker/Dockerfile.nginx --no-cache .
```


## Run

```bash
$ docker run -it -d -p 8000-8009:8000-8009/tcp --name victoriabros_nginx victoriabros/nginx
$ curl http://localhost:8000/echo.json
{
    "message": "Hello from a.example"
}

$ curl http://localhost:8001/echo.json
{
    "message": "Hello from b.example"
}
```
