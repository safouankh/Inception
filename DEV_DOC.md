# Developer Documentation

## 1. Overview

This project implements a containerized WordPress environment using Docker Compose.

The architecture contains three services:

| Service | Responsibility | Internal port |
|---|---|---|
| NGINX | HTTPS and reverse proxy | 443 |
| WordPress/PHP-FPM | Executes PHP and runs WordPress | 9000 |
| MariaDB | Persistent relational database | 3306 |

Only NGINX publishes a port to the host. WordPress and MariaDB communicate through the dedicated Docker network.

## 2. Prerequisites

The development environment requires:

- A Linux virtual machine.
- Docker Engine.
- Docker Compose.
- GNU Make.
- Git.
- Network access to download the required base packages and WordPress files during image building or initialization.

The project must be built and run in the virtual machine.

## 3. Project Structure

The repository contains a root Makefile, environment configuration, secret files, Docker Compose configuration, and separate service directories.

A typical layout is:

```text
inception/
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        └── mariadb/
            ├── Dockerfile
            ├── conf/
            └── tools/
```

## 4. Configuration

### Environment variables

The `.env` file supplies configuration values used by Docker Compose and, where configured, the containers.

Typical settings include:

- Domain name.
- Database name and username.
- WordPress administrator username and email.
- WordPress secondary-user username and email.

### Docker secrets

Passwords are supplied through secret files and mounted into the relevant containers.

Inside a container, a secret is normally accessed through a path such as:

```text
/run/secrets/db_pwd
```

The secret name must match its declaration in the Compose configuration.

Do not commit actual passwords, private keys, or other sensitive files to Git.

## 5. Building and Launching

From the repository root, build and start the application with:

```bash
make
```

The Makefile should invoke Docker Compose to build the custom images and launch the services.

To build the services explicitly:

```bash
docker compose -f srcs/docker-compose.yml build
```

To start the stack in the background:

```bash
docker compose -f srcs/docker-compose.yml up
```

## 6. Container Management

Check service status:

```bash
docker compose -f srcs/docker-compose.yml ps
```

View logs:

```bash
docker compose -f srcs/docker-compose.yml logs
```

Rebuild images after Dockerfile or build-configuration changes:

```bash
docker compose -f srcs/docker-compose.yml up --build
```

Stop and remove the containers and Compose network:

```bash
docker compose -f srcs/docker-compose.yml down
```

This command does not normally remove named volumes.

Avoid using `docker compose down -v` unless you intentionally want to remove the Compose-managed volumes and their stored data.

## 7. Networking

The services use a dedicated Docker network.

WordPress connects to MariaDB using the MariaDB service name and port 3306.

NGINX forwards PHP requests to the WordPress service on port 9000.

Container-to-container communication uses service names rather than host-published ports.

Only NGINX should expose port 443 to the host.

## 8. Persistent Storage

Persistent data is stored under `/home/sael-kha/data` on the virtual machine.

The named volumes use host-backed storage for:

- MariaDB data, mounted inside the container at `/var/lib/mysql`.
- WordPress files, mounted inside the container at `/var/www/html`.

The exact host directories are defined in the Compose volume configuration.

Named volumes allow the data to survive container recreation, provided that the same volumes are reused.

## 9. Troubleshooting

### A container exits

Inspect its logs:

```bash
docker compose -f srcs/docker-compose.yml logs <service>
```

Replace `<service>` with `nginx`, `wordpress`, or `mariadb`.

### WordPress cannot connect to MariaDB

Check that:

- MariaDB is running and ready.
- The database name and database username are correct.
- The password secret is mounted and readable by the startup process.
- The database user has the required privileges.
- Both services are connected to the same Docker network.

### NGINX cannot execute PHP

Check that:

- PHP-FPM is running.
- PHP-FPM listens on port 9000.
- NGINX uses the correct WordPress service name in `fastcgi_pass`.
- NGINX and WordPress share the WordPress files volume.
- The PHP script path passed to FastCGI is correct.

### The domain is inaccessible

Check the domain configuration, VM IP address, network mode, firewall, port 443 mapping, and TLS certificate configuration.

## 10. Security and Maintenance

- Keep passwords and secret files out of version control.
- Expose only the required public service.
- Use the required TLS protocol versions.
- Back up database and website data before destructive operations.
- Do not remove persistent volumes during routine container rebuilds.
- Review logs after rebuilding or restarting services.
