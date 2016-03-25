require 'setting_accessors/configuration/global_setting_configurator'
require 'ostruct'

module SettingAccessors
  module Configuration
    class Base

      DEFAULTS = {
          :setting_class_name => 'Setting',
          :global_settings    => {}
      }.freeze

      #----------------------------------------------------------------
      #                        Global Settings
      #----------------------------------------------------------------

      #
      # Adds a new global setting configuration to the system.
      #
      # @yield a +GlobalSettingConfigurator+ of the `polymorphic` type
      #
      def global_setting!(name)
        configurator = SettingAccessors::Configuration::GlobalSettingConfigurator.new
        yield configurator if block_given?
        configuration_hash(:global_settings)[name.to_sym] = configurator.to_h
      end

      #
      # @return [OpenStruct, NilClass] the global setting's options or +nil+
      #   if no such setting exists.
      #
      def global_setting(name)
        setting = configuration_hash(:global_settings)[name.to_sym]
        setting && OpenStruct.new(setting)
      end

      #
      # @return [true, false] +true+ if there is a global setting with the given +name+
      #
      def global_setting?(name)
        global_settings.has_key?(name.to_sym)
      end

      #
      # @return [Hash] all globally defined settings, mapping their name to their options
      #
      def global_settings
        config_or_default(:global_settings)
      end

      #----------------------------------------------------------------
      #                        Class-Wise Settings
      #----------------------------------------------------------------

      #
      # Adds a new class-wise setting to the system
      #
      # @param [Class, String, Symbol] klass
      #   The class or class name the new setting belongs to
      #
      # @param [String, Symbol] setting_name
      #   The new setting's name
      #
      # @param [Hash] options
      #   The new setting's options
      #
      def class_setting!(klass, setting_name, options = {})
        configuration_hash(:class_settings, klass.to_s.underscore.to_sym)[setting_name.to_sym] = options
      end

      #
      # @return [OpenStruct, NilClass]
      #   The configuration for the given setting name in the given class or +nil+
      #   if no such setting has been defined previously
      #
      def class_setting(klass, setting_name)
        setting = configuration_hash(:class_settings, klass.to_s.underscore.to_sym)[setting_name.to_sym]
        setting && OpenStruct.new(setting)
      end

      #----------------------------------------------------------------
      #                        Helper Methods
      #----------------------------------------------------------------

      #
      # @return [OpenStruct, NilClass] The configuration data for the requested setting or +nil+
      #   if neither a class setting nor a global setting of this name exists.
      #
      #   - If it's a globally defined setting, the value is taken from the global configuration
      #   - If it's a setting defined in a setting_accessor call, the information is taken from this call
      #
      def setting(name, assignable = nil)
        (assignable && class_setting(assignable.class, name)) ||
            global_setting(name) ||
            nil
      end

      def setting?(*args)
        setting(*args).any?
      end

      def reset!
        @configuration = {}
      end

      #----------------------------------------------------------------
      #                        Gem Settings
      #----------------------------------------------------------------

      def setting_class
        config_or_default(:setting_class_name).constantize
      end

      def setting_class=(new_class_name)
        configuration_hash[:setting_class_name] = new_class_name.to_s
      end

      private

      def configuration_hash(*sub_keys)
        sub_keys.inject(@configuration ||= {}) do |h, k|
          h[k] ||= {}
        end
      end

      #
      # @return [Object] a base configuration value (non-namespaced) or
      #   the default value (see DEFAULTS) if none was set yet.
      #
      def config_or_default(name)
        configuration_hash.fetch(name.to_sym, DEFAULTS[name.to_sym])
      end
    end

  end
end
