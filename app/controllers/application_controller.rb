class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  protected

  def check_during(opt={})
    opt[:default] ||= [Date.today - 1.week, Date.today + 2.week]
    params[:begin_date] ||= opt[:default][0].strftime("%m/%d/%Y")
    params[:finish_date] ||= opt[:default][1].strftime("%m/%d/%Y")
    @begin_date = Date.strptime(params[:begin_date], "%m/%d/%Y") rescue nil
    @finish_date = Date.strptime(params[:finish_date], "%m/%d/%Y") rescue nil
  end

  def add_breadcrumb(name, url, options={})
    @breadcrumbs ||= []
    @breadcrumbs << {name: name, url: url, options: options}
  end

end
