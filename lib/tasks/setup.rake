namespace :setup do
    desc 'Setup Rails application'
    task :all => [:bundle_install, :db_setup]

    task :bundle_install do
        puts 'Running bundle install...'
        system('bundle install')
    end

    task :db_setup => [:db_create, :db_migrate, :db_seed]

    task :db_create do
        unless ActiveRecord::Base.connection_config[:database].blank? || ActiveRecord::Base.connected?
            puts 'Creating database...'
            system('rails db:create')
        end
    end

    task :db_migrate do
        unless ActiveRecord::Base.connection_config[:database].blank? || ActiveRecord::Base.connected?
            puts 'Database not configured or connected. Skipping migrations...'
            next
        end

        migrations_pending = ActiveRecord::Migration.check_pending!
        if migrations_pending
            puts 'Running migrations...'
            system('rails db:migrate')
        else
            puts 'Migrations are already up-to-date. Skipping...'
        end
    end

    task :db_seed do
        unless ActiveRecord::Base.connection_config[:database].blank? || ActiveRecord::Base.connected?
            puts 'Database not configured or connected. Skipping seeding...'
            next
        end

        puts 'Seeding database...'
        system('rails db:seed')
    end
end
