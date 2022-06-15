class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:live_ping]

  CONTROLS = {
    execution: {
      check: "Similar with background routine check",
      run: "Only run current executions",
      expend: "Only expand execution by current plan routine",
      verify: "Only verify running executions",
    },
    report: {
      export: "Export configuration as json file",
    },
    testing: {
      send_email: "Testing if email will send correctly",
      error: "Testing if error will get reported",
      worker: "Testing background worker is running",
    },
  }

  def index
    set_tab :dashboard, :nav
    self.check_during([Date.today, Date.today])
    params[:display_as] ||= 'day'
    @executions = self.search_executions(Execution.all).preload(plan: :application)
  end

  def live_ping
    render plain: "ok"
  end

  def check
    case params[:kind]
    when 'error'
      raise "check error"
    when 'worker_error'
      TestWorker.perform_async('error')
      render json: {status: "queue worker error"}
    else
      render json: {status: "ok"}
    end
  end

  def op
    case params[:type]
    when 'execution_check', 'execution_run', 'execution_expand', 'execution_verify'
      @now = Time.now
      type = {
        'execution_check' => 'check',
        'execution_run' => 'run_executions',
        'execution_expand' => 'expand_executions',
        'execution_verify' => 'verify_executions',
      }[params[:type]]
      @result = Scheduler::Runner.send(type, @now)
      render "check_result"
    when "report_export"
      data = Plan.all.preload(:routines).map do |plan|
        d = plan.as_json
        d.delete('execution_method_id')
        d[:execution_method] = plan.execution_method.as_json
        d[:routines] = plan.routines.map(&:as_json)
        d
      end
      render json: JSON.pretty_generate(data)
    when "testing_error"
      raise "test raising error"
    when "testing_send_email"
      UserMailer.test_email(current_user).deliver_now
      redirect_to :root, notice: "Email sent."
    when "testing_worker"
      @result = TestWorker.verify
      redirect_to :root, notice: (@result ? 'validate_worker_ok' : 'validate_worker_failed')
    end
  end

  def sidekiq
    set_tab :sidekiq, :nav
  end

  def info
    @info = {
      environment: {
        rails: Rails.env,
      },
      version: {
        ruby: RUBY_VERSION,
        rails: Rails::VERSION::STRING,
      },
      time: {
        system: {
          time: Time.now.to_s,
          zone: Time.now.zone,
        },
        rails: {
          time: Time.zone.now,
          zone: Time.zone.to_s,
        },
        user: {
          time: Time.now.in_time_zone(current_user.timezone),
          zone: current_user.timezone,
        }
      },
    }
  end

  def profile
    if (request.post? and
        current_user.update_attributes(
          params.require(:item).permit(
            :timezone, :email_notify,
            :email_daily_report, :email_daily_report_time,
          )))
      flash[:notice] = "Updated."
    end
  end

end
