# Docker Restic Cron

There are undoubtedly better containers out there but many I cam across used custom base images, which I am not a fan of. This container builds of the amazing [LinuxServer base image](https://github.com/linuxserver/docker-baseimage-alpine) container and uses the [cron universal mod](https://github.com/linuxserver/docker-mods/tree/universal-cron) to run.

Performs a restic backup to a specified repository at the specified cron intervals. The default behavior is to set use the same restic repository for multiple hosts. As long as the repository is not exclusively locked (see `prune` or `check`), then multiple hosts can back up at the same time.

By default, the repo compression is set to `max` and will keep 7 daily, 4 weekly, 6 monthly and 2 yearly snapshots for any given host.

> ### Important
> You must set the `RESTIC_HOSTNAME` variable otherwise the Docker hostname will be used and could cause issues if ever the container is recreated

## Usage
Edit the `docker-compose.yml` file to point to your backup location by modifying the `RESTIC_REPOSITORY` variable.
More information on backup locations can be found [here](https://restic.readthedocs.io/en/latest/030_preparing_a_new_repo.html#)

```bash
docker-compose up -d
```

## Before/After Hooks
You can place scripts in the config directory under `/config/scripts/before` and `/config/scripts/after`. These scripts will be run before each backup and after each backup. The example script in `example_scripts` will send a notifiction to a `Gotify` instance, alerting that a backup is starting.