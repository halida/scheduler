class Scheduler::Workflow::Execution < Scheduler::Workflow::Base

  OPS = {
    perform: "Run this execution",
    close: "Set this execution as succeeded",
  }

  def op(type)
    case type
    when "perform"
      @item.perform
      {target: @item, msg: "Running"}
    when "close"
      @item.started_at = Time.now
      @item.close
      {target: @item, msg: "Closed"}
    else
      {target: @item, msg: "Unknown operation: #{type}"}
    end
  end

end
