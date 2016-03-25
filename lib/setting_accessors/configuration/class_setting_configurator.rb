module SettingAccessors
  module Configuration
    class ClassSettingConfigurator < ::Struct.new(:type, :default)
      def initialize(type = 'polymorphic')
        super
      end
    end
  end
end
