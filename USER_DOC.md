# User Documentation

## 1. Introduction

This project provides a WordPress website backed by MariaDB and served securely through NGINX.

The stack consists of:

- **NGINX:** Receives HTTPS requests.
- **WordPress with PHP-FPM:** Runs the website.
- **MariaDB:** Stores website content, accounts, and other WordPress data.

## 2. Starting the Project

Open a terminal in the project directory on the Linux virtual machine.

Start the application using:

```bash
make
```

The Makefile builds and starts the services according to the project configuration.

## 3. Stopping the Project

Use the stop target provided by the Makefile. If the project uses the standard Compose command, you can stop the services with:

```bash
docker compose -f srcs/docker-compose.yml down
```

Stopping the containers does not normally delete persistent named volumes.

Do not remove volumes unless you intend to delete the stored website or database data.

## 4. Accessing the Website

Open a browser and navigate to:

`https://sael-kha.42.fr`

The domain must resolve to the virtual machine's IP address. The VM's network must also allow access to port 443.

If a self-signed TLS certificate is used, the browser may display a certificate warning.

## 5. Accessing the Administration Panel

The WordPress administration panel is available at:

`https://sael-kha.42.fr/wp-admin/`

Sign in using the WordPress administrator account configured during installation.

The WordPress administrator account is separate from the MariaDB database account.

## 6. Credentials and Secrets

The project uses configuration variables and Docker secrets to supply credentials.

- `.env` contains the environment variables required by the Compose configuration.
- Secret files provide sensitive values to the services that require them.
- Secrets mounted into a container are available under `/run/secrets/`.

Keep all passwords private. Do not publish secret files or commit them to Git.

If a password needs to be changed, update the relevant secret and follow the appropriate database or WordPress password-change procedure. Updating a secret file alone does not automatically change an existing database account's password.

## 7. Checking Service Status

To check the containers:

```bash
docker compose -f srcs/docker-compose.yml ps
```

To inspect the logs:

```bash
docker compose -f srcs/docker-compose.yml logs nginx
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs mariadb
```

To follow logs while services run:

```bash
docker compose -f srcs/docker-compose.yml logs
```

Check that all three services are running and that their logs do not show persistent errors.

## 8. Persistent Data

The project stores persistent data under:

`/home/sael-kha/data`

The configured volumes preserve:

- MariaDB database files.
- WordPress website files, including uploaded media and plugins.

Recreating containers should not remove this data when the same volumes are reused.

Always back up important website and database data before making destructive changes.
