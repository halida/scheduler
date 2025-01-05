class ExecutionsController < SimpleController
  set_tab :executions, :nav

  def index
    self.check_during([Date.today - 1.day, Date.today + 4.day])
    @items = self.search_executions(@items)
  end

  def op
    result = @item.workflow.op(params[:type])
    redirect_to(result[:target], notice: result[:msg])
  end

  private

  def resource_params
    params.require(:item).permit(:scheduled_at)
  end

end
