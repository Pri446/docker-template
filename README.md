# Laravel deployment template

This repository is the Docker template consumed by the Ansible Laravel deployment playbook.

The deployment model is:

- PHP, Composer, NPM, and Artisan run in this project.
- The Laravel source is mounted under `/var/www/html/<project-name>`.
- The playbook connects PHP to the external `shared-web` Docker network.
- The server's shared Nginx service handles HTTP and HTTPS traffic.
- This repository intentionally does not contain or start a project-specific Nginx container.

## Services

The Compose files provide these services:

- `php`
- `queue-worker`
- `composer`
- `npm`
- `artisan`

The playbook dynamically updates the project name, source directory, container names, PHP version, environment values, and external network definitions.

## Deployment

Run the Ansible playbook from the server-setup repository. It clones this template, clones the Laravel application into `src/<project-name>-<repository-name>`, prepares the containers, and registers the PHP container with shared Nginx.

The Laravel repository should contain at least:

- `artisan`
- `composer.json`
- `.env.example`
- `public/index.php`

For reproducible frontend deployment, it should also contain `package.json` and `package-lock.json`.

## Local helper commands

From a prepared project directory, the command services can be used with:

```bash
docker compose run --rm composer install
docker compose run --rm npm ci
docker compose run --rm artisan migrate
```

The project Compose file is not a standalone web server. Access the application through the shared Nginx configuration created by the deployment process.
