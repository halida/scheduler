class SimpleController < ApplicationController
  load_and_authorize_resource param_method: :resource_params, instance_name: :item
  before_action :set_breadcrumbs

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
      redirect_to @item, notice: "##{self.class_title}: ##{@item.id} #{@item.title} Created!"
    else
      render :edit
    end
  end

  def edit
  end

  def update
    if @item.update_attributes(resource_params)
      redirect_to @item, notice: "##{self.class_title}: ##{@item.id} #{@item.title} Updated!"
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to self.after_deploy_path, notice: "##{self.class_title}: ##{@item.id} #{@item.title} Deleted!"
  end

  protected

  def check_during
    params[:begin_date] ||= (Date.today - 1.week).strftime("%m/%d/%Y")
    params[:finish_date] ||= (Date.today + 2.week).strftime("%m/%d/%Y")
    @begin_date = Date.strptime(params[:begin_date], "%m/%d/%Y") rescue nil
    @finish_date = Date.strptime(params[:finish_date], "%m/%d/%Y") rescue nil
  end

  def add_breadcrumb(name, url, options={})
    @breadcrumbs ||= []
    @breadcrumbs << {name: name, url: url, options: options}
  end

  def after_deploy_path
    [self.controller_name]
  end

  def class_title
    self.controller_name.humanize.titleize
  end

  def set_breadcrumbs
    add_breadcrumb self.class_title, File.join('/', self.controller_path)
    case params[:action]
    when "new", "create"
      add_breadcrumb "new", File.join('/', self.controller_path, 'new')
    when "show", "edit", "update"
      add_breadcrumb "##{@item.id} #{@item.try(:title)}", [@namespace, @item]
    end
  end
end
