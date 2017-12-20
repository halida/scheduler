class ExecutionMethodsController < SimpleController
  set_tab :execution_methods, :nav

  private

  def resource_params
    params.require(:item).permit(:title, :execution_type, :parameters_text, :enabled)
  end
end
