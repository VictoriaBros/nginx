# nginx

This nginx repository was created to support Victoria Bros. ever growing services, which allows us to store Nginx server conf. file close to the service and dynamically to them dynamically load them into the running nginx instance.


## Structure

- docker - includes Dockerfile.nginx for building and running nginx and its configurations
- nginx/nginx.conf - Nginx configuration file is nginx.conf and loaded into /etc/nginx/nginx.conf on Ubuntu systems
- nginx/ssl - includes dhparam and options-ssl files that will be loaded by nginx/conf.d/ssl.conf
- nginx/data - includes data for the example domains
- nginx/conf.d - includes service and necessary configuration files that is loaded by nginx
- nginx/conf.d/base.conf - includes generic nginx configuration
- nginx/conf.d/ssl.conf - add or replace ssl related nginx configuration

### nginx/nginx.conf

This include directive in nginx.conf loads all `.conf` files in the conf.d directory and nested in the http block which implies it only load server related configuration which allows isolation of individual configuration.

```bash
include /etc/nginx/conf.d/*.conf;
```


## Configuration

## Build

Replace the placeholder `<replace_with_github_token>` in file `docker/.env.docker` with a [fine-grained token from GitHub](https://github.com/settings/tokens) with lifetime less than 366days, selected repositories and permissions:

- Contents as **Read-Only**

```bash
# change docker env to own credentials and preference
$ vim docker/.env.docker
$ cat docker/.env.docker | xargs printf -- '--build-arg %s\n' | xargs docker build -t victoriabros/nginx -f docker/Dockerfile.nginx --no-cache .
```


## Run

```bash
# run docker image with port range
$ docker run -it -d -p 8000-8009:8000-8009/tcp --name victoriabros_nginx victoriabros/nginx

# send an HTTP request to our server and check the output
$ curl http://localhost:8000/echo.json
{
    "message": "Hello from a.example"
}

$ curl http://localhost:8001/echo.json
{
    "message": "Hello from b.example"
}
```

## Advanced

Run the below command to get generated output on how to perform the following actions:

- Request [LetsEncypt certificate](https://letsencrypt.org)
- Build Nginx image
- Create Docker network
- Start Nginx containers
- Renew [LetsEncypt certificate](https://letsencrypt.org)
- Request [LetsEncypt certificate](https://letsencrypt.org) for wildcard domain
- Add DNS TXT to domain provider

Note: This generated output assumes you are running and exposing just one service `service-a.example.conf`, `ssl.conf` and exposing just port 80 and 443.

```bash
$ SERVICE_DNS=example.com WILDCARD_DNS=*.example.com ORG_NAME=victoriabros ORG_EMAIL=technology@victoriabros.com ./nginx.sh
```
