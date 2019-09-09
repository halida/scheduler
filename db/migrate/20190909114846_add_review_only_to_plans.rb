class AddReviewOnlyToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :review_only, :boolean, default: false
  end
end
