class HomeController < ApplicationController

  def index
    set_tab :dashboard, :nav
    self.check_during([Date.today, Date.today])
  end

  def op
    case params[:type]
    when "check", "run_executions", "expend_executions", "verify_executions"
      @now = Time.now
      @result = Scheduler::Runner.send(params[:type], @now)
      render "check_result"
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
      },
    }
  end

  def profile
    if request.post? and current_user.update_attributes(params.require(:item).permit(:timezone))
      flash[:notice] = "Updated."
    end
  end

end
