class ExecutionsController < SimpleController
  before_action :check_during, on: [:index]
  set_tab :executions, :nav

  def index
    @items = self.class.search_executions(params, @items, @begin_date, @finish_date)
  end

  def self.search_executions(params, executions, begin_date, finish_date)
    executions.during(begin_date, finish_date).
      preload(:plan, :routine).
      where_if(params[:status].present?, status: params[:status]).
      where_if(params[:include_initialize] != '1', "status != ?", :initialize).
      order(scheduled_at: :desc).
      paginate(page: params[:page])
  end

  def op
    case params[:type]
    when "perform"
      @item.perform
      redirect_to @item, notice: "Finished."
    when "close"
      @item.close
      redirect_to @item, notice: "Closed."
    end
  end

  private

  def resource_params
    params.require(:item).permit(:scheduled_at)
  end

end
