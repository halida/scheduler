class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.string :name
      t.text :description

      t.string :token
      t.boolean :enabled, default: true

      t.timestamps null: false
    end

    add_column :plans, :application_id, :integer
    add_index :plans, :application_id
  end
end
