module SettingAccessors
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      argument :model_name, :type => :string, :default => 'Setting'

      def self.next_migration_number(path)
        if @prev_migration_nr
          @prev_migration_nr += 1
        else
          @prev_migration_nr = Time.now.utc.strftime('%Y%m%d%H%M%S').to_i
        end
        @prev_migration_nr.to_s
      end

      desc 'Installs everything necessary'
      def create_install
        template 'model.rb.erb', "app/models/#{model_name.classify.underscore}.rb"
        template 'initializer.rb.erb', 'config/initializers/setting_accessors.rb'
        migration_template 'migration.rb.erb', "db/migrate/create_#{model_name.classify.underscore.pluralize}.rb"
      end
    end
  end
end
