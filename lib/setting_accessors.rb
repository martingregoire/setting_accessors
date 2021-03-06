require 'setting_accessors/version'
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
  def self.setting_class
    self.setting_class_name.constantize
  end

  def self.setting_class=(klass)
    @@setting_class = klass.to_s
  end

  def self.setting_class_name
    (@@setting_class ||= 'Setting').camelize
  end
end
