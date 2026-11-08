*This project has been created as part of the 42 curriculum by sael-kha.*

# Inception

## Description

**Inception** is a system administration project focused on Docker and Docker Compose. The goal is to build a small, secure and persistent infrastructure using multiple containers, each running a specific service.

The infrastructure consists of three main services:

- **NGINX:** Acts as the web server and the only public entry point. It handles HTTPS connections using TLS.
- **WordPress + PHP-FPM:** Runs WordPress and processes PHP requests.
- **MariaDB:** Stores the WordPress database, including users, posts and configuration data.

Each service is built from its own Dockerfile using Debian as the base image. The services communicate through a dedicated Docker network, and named volumes provide persistent storage.

The website is accessible through the domain `sael-kha.42.fr` over HTTPS.

### Project objectives

- Learn how to build and manage Docker images and containers.
- Understand Docker Compose and service orchestration.
- Configure communication between isolated containers.
- Deploy a website using NGINX, WordPress, PHP-FPM and MariaDB.
- Configure HTTPS using TLS.
- Persist application files and database data across container restarts and recreation.
- Manage configuration and credentials securely.
- Understand container processes, networking, volumes and service dependencies.

## Architecture and design choices

### Infrastructure overview

NGINX forwards PHP requests to WordPress through PHP-FPM. WordPress communicates with MariaDB using the database service name and its internal port.

Only NGINX exposes a public port to the host. WordPress/PHP-FPM and MariaDB communicate internally through the Docker network.

### Sources included in the project

- `Makefile`: Automates building, starting and stopping the infrastructure.
- `docker_compose.yml`: Defines the services, networks, volumes, environment variables and secrets.
- `.env`: Stores non-secret configuration values.
- `secrets/`: Contains sensitive credentials used by the services.
- `srcs/requirements/nginx/`: NGINX Dockerfile, configuration and startup script.
- `srcs/requirements/wordpress/`: WordPress/PHP-FPM Dockerfile and initialization scripts.
- `srcs/requirements/mariadb/`: MariaDB Dockerfile, configuration and initialization scripts.
- `USER_DOC.md`: Explains how to use and access the running application.
- `DEV_DOC.md`: Explains the development environment, configuration and maintenance commands.

## Instructions

### Prerequisites

The following tools are required:

- Linux virtual machine.
- Docker Engine.
- Docker Compose plugin.
- `make`.
- Git.

### Configuration

1. Clone the repository and enter the project directory.
2. Configure the required non-secret variables in `.env`, including the domain name and database/WordPress configuration.
3. Create the required secret files in `secrets/` according to the names expected by your Docker Compose file.
4. Ensure that the configured persistent data directories exist under `/home/sael-kha/data`.
5. Ensure that `sael-kha.42.fr` resolves to the IP address of the virtual machine from the machine running the browser.

Do not commit passwords or other sensitive credentials to Git.

### Build and start the infrastructure

From the root of the repository, use the Makefile if it defines the project startup target:

```bash
make
```

Alternatively, if your Compose file is named `docker_compose.yml`:

```bash
docker compose -f ./docker_compose.yml up --build
```

### Access the website

Open the following address in your browser:

**https://sael-kha.42.fr**

The browser may display a certificate warning because the project uses a locally generated, self-signed TLS certificate.

### Useful commands

Check the status of the containers:

```bash
docker compose -f ./docker_compose.yml ps
```

View service logs:

```bash
docker compose -f ./docker_compose.yml logs
```

Follow the logs of a specific service:

```bash
docker compose -f ./docker_compose.yml logs wordpress
```

Stop the infrastructure without deleting persistent volumes:

```bash
docker compose -f ./docker_compose.yml down
```

Rebuild the images and recreate the containers:

```bash
docker compose -f ./docker_compose.yml up --build
```

**Warning:** Avoid `docker compose down -v` unless you intentionally want to remove the named volumes and their persistent data.

For detailed user instructions and development procedures, see `USER_DOC.md` and `DEV_DOC.md`.

## Required comparisons

### 1. Virtual Machines vs Docker

| Virtual Machines | Docker |
|---|---|
| Each VM runs its own operating system and kernel. | Containers share the host kernel. |
| Usually requires more memory and storage. | Usually has lower resource overhead. |
| Boots a complete operating system. | Starts isolated application processes. |
| Provides a separate OS environment. | Provides process, filesystem and network isolation. |
| Useful for running different operating systems. | Useful for packaging and deploying applications consistently. |

**Design choice:** This project uses a virtual machine as the required development and evaluation environment, with Docker containers running the application services inside it. This combines VM-level isolation with the lightweight deployment model of containers.

### 2. Secrets vs Environment Variables

| Secrets | Environment variables |
|---|---|
| Intended for sensitive values such as passwords. | Suitable for non-sensitive configuration. |
| Can be provided to containers through dedicated secret mechanisms. | Commonly configured through Compose and `.env` files. |
| Can reduce accidental exposure of credentials in configuration. | Values may be visible through container inspection or process environments. |
| Require appropriate file permissions and access management. | Convenient for configuring ports, domain names and service settings. |

**Design choice:** Non-sensitive configuration is stored in `.env`, while sensitive credentials are provided through the project's secrets mechanism. Secret files must be protected and excluded from version control.

### 3. Docker Network vs Host Network

| Docker Network | Host Network |
|---|---|
| Provides an isolated network for containers. | Shares the host's network namespace on supported platforms. |
| Containers can communicate using service names. | Services use the host's networking environment directly. |
| Allows explicit network-level separation. | Reduces network isolation and can cause port conflicts. |
| Supports internal service communication without publishing every port. | Does not provide the same independent container network isolation. |

**Design choice:** A dedicated Docker network allows NGINX, WordPress and MariaDB to communicate internally. Only NGINX publishes port `443` to the host, keeping the database and PHP-FPM services off the public interface.

### 4. Docker Volumes vs Bind Mounts

| Docker Volumes | Bind Mounts |
|---|---|
| Managed by Docker. | Map a specific host filesystem path into a container. |
| Stored in Docker-managed storage by default. | Use a path explicitly selected by the developer. |
| Can persist data independently of containers. | Can also persist data independently of containers. |
| Convenient for database and application data. | Convenient for development files and direct host access. |

**Design choice:** Named volumes are used for persistent WordPress website files and MariaDB database data. The project stores persistent data under `/home/sael-kha/data`, as required by the subject. Bind mounts are useful when direct access to host files is necessary, but named volumes provide convenient Docker-managed persistence.

## Resources

### Official documentation

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [Docker storage documentation](https://docs.docker.com/engine/storage/)
- [Docker networking documentation](https://docs.docker.com/engine/network/)
- [Docker secrets documentation](https://docs.docker.com/engine/swarm/secrets/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [WordPress documentation](https://developer.wordpress.org/)
- [WordPress installation guide](https://developer.wordpress.org/advanced-administration/before-install/howto-install/)
- [PHP-FPM documentation](https://www.php.net/manual/en/install.fpm.php)
- [MariaDB documentation](https://mariadb.com/kb/en/documentation/)
- [OpenSSL documentation](https://docs.openssl.org/)

### Use of AI

AI tools were used as learning and development assistance during this project.

They were used to:

- Explain Docker concepts, including images, containers, networks, volumes and PID 1.
- Help understand and troubleshoot Dockerfiles, Docker Compose configuration and service communication.
- Assist with debugging NGINX, WordPress/PHP-FPM and MariaDB configuration and startup issues.
- Explain shell scripts, environment variables, secret handling and TLS certificate generation.
- Help structure and review project documentation.

AI-generated suggestions were reviewed and tested against the actual project where applicable. AI was used as a support tool for understanding and debugging; the final configuration, testing and verification remain the responsibility of the project author.

## Author

**sael-kha** — 42 / 1337 MED student.