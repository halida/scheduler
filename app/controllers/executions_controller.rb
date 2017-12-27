class ExecutionsController < SimpleController
  set_tab :executions, :nav

  DISPLAY_AS = {
    'list' => "List",
    'day' => "One day",
  }

  def index
    self.check_during([Date.today - 1.day, Date.today + 4.day])
    @items = self.search_executions(@items)
  end

  def op
    case params[:type]
    when "perform"
      @item.perform
      redirect_to @item, notice: "Finished."
    when "close"
      @item.started_at = Time.now
      @item.close
      redirect_to @item, notice: "Closed."
    end
  end

  private

  def resource_params
    params.require(:item).permit(:scheduled_at)
  end

end
