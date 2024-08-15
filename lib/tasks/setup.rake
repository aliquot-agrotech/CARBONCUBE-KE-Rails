require 'dotenv'
Dotenv.load

namespace :setup do
  desc 'Setup Rails application'
  task :all => [:bundle_install, :db_setup]

  task :bundle_install do
    puts 'Running bundle install...'
    system('bundle install')
  end

  def establish_connection
    db_config = {
      adapter:  'postgresql',
      host:     ENV['DB_HOST'] || 'localhost',
      username: ENV['DB_USERNAME'] || 'postgres',
      password: ENV['DB_PASSWORD'] || ENV['DEVELOPMENT_DATABASE_PASSWORD'],
      database: ENV['DB_NAME'] || 'carbonecomrails_development',
      port:     ENV['DB_PORT'] || 5432
    }
    # puts "Connecting with config: #{db_config.inspect}"
    ActiveRecord::Base.establish_connection(db_config)
  end

  task :db_setup => [:db_create, :db_migrate, :db_seed]

  task :db_create do
    puts 'Creating database...'
    system('rails db:create')
  end

  task :db_migrate do
    begin
      establish_connection
      if ActiveRecord::Base.connection
        puts 'Running migrations...'
        system('rails db:migrate')
      end
    rescue ActiveRecord::NoDatabaseError
      puts 'Database does not exist. Skipping migrations...'
    rescue PG::ConnectionBad => e
      puts "Connection failed: #{e.message}"
    end
  end

  task :db_seed do
    begin
      establish_connection
      if ActiveRecord::Base.connection
        puts 'Seeding data for the database...'
        system('rails db:seed')
      end
    rescue ActiveRecord::NoDatabaseError
      puts 'Database does not exist. Skipping seeding...'
    rescue PG::ConnectionBad => e
      puts "Connection failed: #{e.message}"
    end
  end

  
end

