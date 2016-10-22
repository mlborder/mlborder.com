namespace :mlborder do
  namespace :development do
    desc 'Preparing development environment.'
    task :initialize => :environment do
      puts 'Initializing administrator.'
      User.find_or_initialize_by(provider: 'twitter', uid: '149092237') do |admin|
        admin.screen_name = 'treby006'
        admin.name = 'treby'
        admin.role = :role_admin
        admin.save
      end

      puts 'Initializing events.'
      Event.where("started_at > '2015-01-01 00:00:00 +0900'").order(id: :asc).each do |event|
        puts "#{event.name}"
        event.series_name = event.default_series_name
        event.records_available = true if event.id > 72
        event.save

        next if event.hhp_event? || event.ula_event?
        puts " update final border..."
        event.update_final_border_info!
      end
    end
  end
end
