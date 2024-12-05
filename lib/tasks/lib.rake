namespace :lib do

  task :import, [:application, :filename] => :environment do |_t, args|
    application = args[:application]
    filename = args[:filename]
    puts "import application #{application} from file: #{filename}"

    schedules = eval(File.read(filename))
    Scheduler::Lib.import(application, schedules)
  end

end
