# Docker Restic Cron

Performs a restic backup to a specified repository at the specified cron intervals.

## Usage
Edit the `docker-compose.yml` file to point to your backup location by modifying the `RESTIC_REPOSITORY` variable.
More information on backup locations can be found [here](https://restic.readthedocs.io/en/latest/030_preparing_a_new_repo.html#)
```bash
docker-compose up -d
```
