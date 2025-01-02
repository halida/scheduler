class Api::OpController < ApiController

  def ping
    render plain: "pong"
  end

  def testing_job
    token = \
    begin
      Settings.op.testing_job.token
    rescue Settingslogic::MissingSetting
    end
    return render status: :forbidden unless token.present?

    return render status: :unauthorized if params[:token] != token

    @result = TestJob.verify
    render json: {testing_job: @result}
  end

end
