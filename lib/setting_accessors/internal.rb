#
# This module contains class methods used internally.
#
module SettingAccessors
  module Internal

    def self.ensure_nested_hash!(hash, *keys)
      h = hash
      keys.each do |key|
        h[key] ||= {}
        h = h[key]
      end
    end

    def self.lookup_nested_hash(hash, *keys)
      return nil if hash.nil?

      h = hash
      keys.each do |key|
        return nil if h[key].nil?
        h = h[key]
      end
      h
    end

    #
    # Sets a class-specific setting
    # For global settings, this is done in config/settings.yml
    # Please do not call this method yourself, it is done automatically
    # by using setting_accessor in your model class
    #
    def self.set_class_setting(klass, setting_name, options = {})
      @@class_settings ||= {}

      #If there are no options given, the setting *has* to be defined globally.
      if options.empty? && !self.globally_defined_setting?(setting_name)
        raise ArgumentError.new "The setting '#{setting_name}' in model '#{klass.to_s}' is neither globally defined nor did it receive options"

      #A setting which is already globally defined, may not be re-defined on class base
      elsif self.globally_defined_setting?(setting_name) && options.any?
        raise ArgumentError.new("The setting #{setting_name} is already defined in config/settings.yml and may not be redefined in #{klass}")

      #If the setting is defined on class base, we have to store its options
      elsif options.any? && !self.globally_defined_setting?(setting_name)
        self.ensure_nested_hash!(@@class_settings, klass.to_s)
        @@class_settings[klass.to_s][setting_name.to_s] = options.deep_stringify_keys
      end
    end

    #
    # @return [String] the given setting's value type
    #
    def self.setting_value_type(*args)
      self.setting_data(*args)['type'] || 'polymorphic'
    end

    #
    # @return [SettingAccessors::Converter] A value converter for the given type
    #
    def self.converter(value_type)
      @@converters ||= {}
      @@converters[value_type.to_sym] ||= SettingAccessors::Converter.new(value_type)
    end

    #
    # @return [Hash, NilClass] Information about a class specific setting or +nil+ if it wasn't set before
    #
    def self.get_class_setting(klass, setting_name)
      self.lookup_nested_hash(@@class_settings, klass.to_s, setting_name.to_s)
    end

    #
    # Adds the given setting name to the list of used setting accessors
    # in the given class.
    # This is mainly to keep track of all accessors defined in the different classes
    #
    def self.add_setting_accessor_name(klass, setting_name)
      @@setting_accessor_names ||= {}
      @@setting_accessor_names[klass.to_s] ||= []
      @@setting_accessor_names[klass.to_s] << setting_name.to_s
    end

    #
    # @return [Array<String>] all setting accessor names defined in the given +class+
    #
    def self.setting_accessor_names(klass)
      @@setting_accessor_names ||= {}
      self.lookup_nested_hash(@@setting_accessor_names, klass.to_s) || []
    end

  end
end
