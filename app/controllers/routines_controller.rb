class RoutinesController < SimpleController
  set_tab :routines, :nav

  def index
    redirect_to :plan
  end

  def show
    redirect_to @item.plan
  end

  protected

  def after_deploy_path
    @item.plan
  end

  def resource_params
    params.require(:item).permit(:plan_id, :config, :timezone, :enabled, :modify)
  end
end
