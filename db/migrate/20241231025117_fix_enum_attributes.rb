class FixEnumAttributes < ActiveRecord::Migration[8.0]
  def up
    change_column_default :executions, :status, from: "initialize", to: "init"
    Execution.where(status: "initialize").update_all(status: "init")
    ExecutionMethod.where(execution_type: "none").update_all(execution_type: "no")
  end

  def down
    ExecutionMethod.where(execution_type: "no").update_all(execution_type: "none")
    Execution.where(status: "init").update_all(status: "initialize")
    change_column_default :executions, :status, from: "init", to: "initialize"
  end
end
