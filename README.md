# Scheduler

A tool for monitor and trigger routine tasks.

Usally we create routine task by using `crontab`, but there are more things we could do:

- Monitor if those crontab jobs running correctly.
- A central place to view all scheduled tasks, and list what will run today.
- Improve: instead of using crontab, we need a web UI to configure them.

Scheduler is such a tool.

![dashboard](https://raw.githubusercontent.com/halida/scheduler/master/app/assets/images/dashboard.png)

## Install

- Requirement: Rails, Mysql, Redis
- Goto config, copy *.yml.example to *.yml, and update configuration.
    - If you have [RubyCAS Server](https://github.com/rubycas), you can set it in `application.yml`, otherwise delete those cas_* settings.
- Create Mysql database.
    - Then run `bundle exec rake db:migrate` to create schema.
- Create users manually:
    - Run `make`
    - `User.create(username: "Bob Steven", email: "bob@scheduler.dev", password: "password")`
- Run server:
    - `make run`
    - Goto http://localhost:8080
