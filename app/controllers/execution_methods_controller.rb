class ExecutionMethodsController < SimpleController
  set_tab :execution_methods, :nav

  def show
    @items = Scheduler::Searcher.plans(@item.plans, params)
  end

  private

  def resource_params
    params.require(:item).permit(:title, :execution_type, :parameters_text, :enabled)
  end
end
