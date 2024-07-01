namespace :setup do
    desc 'Setup Rails application'
    task :all => [:bundle_install, :db_setup]
  
    task :bundle_install do
      puts 'Running bundle install...'
      system('bundle install')
    end
  
    task :db_setup => [:db_create, :db_migrate, :db_seed]
  
    task :db_create do
      puts 'Creating database...'
      system('rails db:create')
    end
  
    task :db_migrate do
      begin
        ActiveRecord::Base.establish_connection
        if ActiveRecord::Base.connection
          puts 'Running migrations...'
          system('rails db:migrate')
        end
      rescue ActiveRecord::NoDatabaseError
        puts 'Database does not exist. Skipping migrations...'
      end
    end
  
    task :db_seed do
      begin
        ActiveRecord::Base.establish_connection
        if ActiveRecord::Base.connection
          puts 'Seeding database...'
          system('rails db:seed')
        end
      rescue ActiveRecord::NoDatabaseError
        puts 'Database does not exist. Skipping seeding...'
      end
    end
  end
  