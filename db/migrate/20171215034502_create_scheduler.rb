class CreateScheduler < ActiveRecord::Migration[5.1]
  def change
    create_table :plans do |t|
      t.string :title
      t.text :description

      t.integer :execution_method_id
      t.string :parameters
      t.integer :waiting, default: 60*3

      t.string :token

      t.boolean :enabled, default: true
      t.timestamps null: false
    end
    add_index :plans, :token
    add_index :plans, :execution_method_id

    create_table :execution_methods do |t|
      t.string :title
      t.string :execution_type
      # redis, api, 
      t.text :parameters

      t.boolean :enabled, default: true
      t.timestamps null: false
    end

    create_table :routines do |t|
      t.integer :plan_id

      t.string :config
      t.string :timezone, default: "UTC"
      t.boolean :enabled, default: true
    end
    add_index :routines, :plan_id

    create_table :executions do |t|
      t.integer :plan_id
      t.integer :routine_id

      t.string :token

      t.string :status, default: :initialize
      t.text :log, limit: 262143
      t.text :result, limit: 262143

      t.datetime :scheduled_at
      t.datetime :timeout_at

      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps null: false
    end
    add_index :executions, :token
    add_index :executions, :plan_id
    add_index :executions, :scheduled_at
  end
end
