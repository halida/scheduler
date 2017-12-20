class PlansController < SimpleController
  before_action :check_during, on: [:show]
  set_tab :plans, :nav

  def index
    @items = @items.
               preload(:execution_method, :routines).
               paginate(page: params[:page])
  end

  def show
    set_tab :schedules, :plan
  end

  def executions
    set_tab :executions, :plan
    @executions = ExecutionsController.search_executions(params, @item.executions, @begin_date, @finish_date)
  end

  def op
    case params[:type]
    when "execute"
      e = @item.executions.create!
      e.perform
      redirect_to e, notice: "Executing: ##{e.id}"
    when "expand"
      @item.routines.each do |routine|
        routine.routine_expend_executions(routine, now)
      end
    end
  end

  private
  def resource_params
    params.require(:item).permit(:title, :description)
  end

end
