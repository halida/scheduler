class PlansController < SimpleController
  set_tab :plans, :nav

  def index
    @items = Scheduler::Searcher.plans(@items, params)
  end

  def show
    set_tab :schedules, :plan
    self.check_during([Date.today-1.day, Date.today+4.day])
  end

  def executions
    set_tab :executions, :plan
    self.check_during([Date.today-1.day, Date.today+4.day])
    @executions = search_executions(@item.executions)
  end

  def op
    case params[:type]
    when "execute"
      e = @item.executions.create!
      e.perform
      redirect_to e, notice: "Executing: ##{e.id}."
    when "expand"
      Scheduler::Lib.plan_expand_executions(@item, Time.now)
      redirect_to @item, notice: "Expanded."
    when "assign_token"
      @item.assign_token
      redirect_to @item, notice: "Token assigned."
    when "delete_future_executions"
      @item.executions.scheduled_after(Time.now).where(status: :init).delete_all
      redirect_to @item, notice: "Deleted."
    end
  end

  private
  def resource_params
    params.require(:item).permit(
      :title, :description,
      :application_id, :execution_method_id,
      :parameters_text, :waiting, :enabled, :review_only
    )
  end

end
