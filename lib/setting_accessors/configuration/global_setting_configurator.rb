module SettingAccessors
  module Configuration
    class GlobalSettingConfigurator < ::Struct.new(:type, :default)
      def initialize(type = 'polymorphic')
        super
      end
    end
  end
end
