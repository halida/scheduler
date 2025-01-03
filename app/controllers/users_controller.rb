class UsersController < SimpleController

  private
  def resource_params
    params.require(:item).permit(
      :username, :email, :timezone, :status, :email_notify,
      :email_daily_report, :email_daily_report_time,
    )
  end

end
