class ExecutionsController < SimpleController
  set_tab :executions, :nav

  def index
    self.check_during([Date.today - 1.day, Date.today + 4.day])
    @items = self.class.search_executions(params, @items, @begin_date, @finish_date)
  end

  def self.search_executions(params, executions, begin_date, finish_date)
    executions.during(begin_date, finish_date+1.day).
      preload(:plan, :routine).
      where_if(params[:status].present?, status: params[:status]).
      order(scheduled_at: :asc).
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
