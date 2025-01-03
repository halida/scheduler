namespace :jobs do
  desc "Enqueue Job"
  task enqueue: :environment do
    name = ENV['job']
    name.constantize.perform_later
    puts "#{name} enqueued."
  end
end
