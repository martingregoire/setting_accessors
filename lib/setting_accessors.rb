require 'pathname'
require 'active_support/all'

require 'setting_accessors/version'
require 'setting_accessors/configuration/base'
require 'setting_accessors/accessor'
require 'setting_accessors/converter'
require 'setting_accessors/integration'
require 'setting_accessors/integration_validator'
require 'setting_accessors/internal'
require 'setting_accessors/setting_scaffold'
require 'setting_accessors/validator'

ActiveRecord::Base.class_eval do
  include SettingAccessors::Integration
end

module SettingAccessors
  def self.root
    Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), '..')))
  end

  def self.lib
    self.root.join('lib')
  end

  def self.configuration
    @configuration ||= SettingAccessors::Configuration::Base.new
  end

  def self.configure
    yield configuration
  end
end
