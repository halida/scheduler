class ApplicationsController < SimpleController
  set_tab :applications, :nav

  def index
    @items = Scheduler::Searcher.applications(@items, params)
  end

  def show
    @items = Scheduler::Searcher.plans(@item.plans, params)
  end

  private
  def resource_params
    params.require(:item).permit(
      :name,
    )
  end

end
