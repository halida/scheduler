class Api::OpController < ApiController

  def ping
    render plain: "pong"
  end

  def testing_worker
    token = \
    begin
      Settings.op.testing_worker.token
    rescue Settingslogic::MissingSetting
    end
    return render status: :forbidden unless token.present?

    return render status: :unauthorized if params[:token] != token

    @result = TestWorker.verify
    render json: {testing_worker: @result}
  end

end
