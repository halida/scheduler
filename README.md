# Scheduler

A tool for monitor and trigger routine tasks.

Usally we create routine task by using `crontab`, but there are more things we could do:

- Monitor if those crontab jobs running correctly.
- A central place to view all scheduled tasks, and list what will run today.
- Improve: instead of using crontab, we need a web UI to configure them.

Scheduler is such a tool.

![dashboard](https://raw.githubusercontent.com/halida/scheduler/master/app/assets/images/dashboard.png)

## Install

- Requirement: Rails, Mysql, Redis, [RubyCAS Server](https://github.com/rubycas)
- Goto config, copy *.yml.example to *.yml, and update configuration.
- Create database
- Create a [RubyCAS Server](https://github.com/rubycas) and link to your user authentication database. (TODO: need a standalone user authentication method)


