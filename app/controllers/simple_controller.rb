class SimpleController < ApplicationController
  load_and_authorize_resource param_method: :resource_params, instance_name: :item

  def index
    @items = @items.paginate(page: params[:page])
  end

  def show
  end

  def new
    render :edit
  end

  def create
    if @item.save
      redirect_to User.name.underscore.pluralize, notice: "##{item.class.name.humanize}: #{@item.title} Created!"
    else
      render :edit
    end
  end

  def edit
  end

  def update
    if @item.update_attributes(resource_params)
      redirect_to User.name.underscore.pluralize, notice: "##{item.class.name.humanize}: #{@item.title} Updated!"
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to User.name.underscore.pluralize, notice: "##{item.class.name.humanize}: #{@item.title} Deleted!"
  end

  protected

  def check_during
    params[:begin_date] ||= (Date.today - 1.week).strftime("%m/%d/%Y")
    params[:finish_date] ||= (Date.today + 2.week).strftime("%m/%d/%Y")
    @begin_date = Date.strptime(params[:begin_date], "%m/%d/%Y") rescue nil
    @finish_date = Date.strptime(params[:finish_date], "%m/%d/%Y") rescue nil
  end

end
