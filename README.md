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

## Usage

- Please check [scheduler_test.rb](https://github.com/halida/scheduler/blob/master/test/models/scheduler_test.rb) to see examples.
- The configuration step is like this:
    - Create new plan, assign plan token (used for API call)
    - Create routine for this plan, format is similar with crontab.
- Scheduler will auto create execution by routine configuration.
    - When the time come, the execution status will change from initialize to running.
    - If Scheduler receive a API request for this execution, the status will change to succeeded.
    - If reach timeout, the status will change to timeout, and send email to notify user.
- If you want to send Notify about the result, goto your worker project, use [SchedulerApi](https://github.com/halida/scheduler/blob/master/lib/scheduler_api.rb) to send execution result.
