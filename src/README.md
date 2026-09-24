## Laravel application source

For local development, place the Laravel application in `src/imis-revamp2.0`, or update the Compose volume paths to match your application directory.

For server deployment, the Ansible playbook clones the application into `src/<project-name>-<repository-name>` and updates the Docker paths automatically. The application must contain `artisan`, `composer.json`, and `.env.example`.
