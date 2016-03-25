require_relative '../../../test_helper'

class SettingTest < ActiveSupport::TestCase
  should validate_presence_of :name

  #FIXME: This is currently setting assignable_type and assignable_id to "0" resp. "1" which breaks everything.
  # should validate_uniqueness_of(:name).scoped_to([:assignable_type, :assignable_id])

  context 'The create_or_update function' do
    setup do
      @ash  = User.create(:first_name => 'Ash', :last_name => 'Ketchum')
    end

    should 'create a new assigned setting if it did not exist before' do
      assert Setting.count.zero?
      Setting.create_or_update(:pokedex_count, 151, @ash)
      assert Setting.count == 1
    end

    should 'update an assigned setting if it already exists' do
      Setting.create_or_update(:pokedex_count, 150, @ash)
      assert Setting.count == 1
      Setting.create_or_update(:pokedex_count, 151, @ash)
      assert Setting.count == 1
      assert_equal Setting.pokedex_count(@ash), 151
    end

    should 'return a setting object by default' do
      assert_instance_of Setting, Setting.create_or_update(:pokedex_count, 151, @ash)
    end

    should 'return just the value if wished' do
      assert_equal Setting.create_or_update(:pokedex_count, 151, @ash, true), 151
    end
  end

  context 'The globally_defined method' do
    should 'return true for a setting which is defined in config/settings.yml' do
      assert SettingAccessors::Internal.globally_defined_setting?('a_string')
    end

    should 'return false for a setting which is not defined in config/settings.yml' do
      assert !SettingAccessors::Internal.globally_defined_setting?('something_different')
    end
  end

  context 'setting_accessors' do
    should 'return the default value as fallback if :fallback => :default is given' do
      assert_equal 'I am a string!', User.new.a_string
    end

    should 'return the global setting value as fallback if :fallback => :global is given' do
      Setting.a_number = 42
      assert_equal 42, User.new.a_number
    end

    should 'return the given value as fallback if :fallback => VALUE is given' do
      assert_equal false, User.new.a_boolean
    end
  end

  context 'Class-Defined Settings' do
    should 'have the type defined in the setting_accessor call' do
      assert u = User.create(:first_name => 'a', :last_name => 'name', :locale => 'de')
      assert s = Setting.setting_record(:locale, User.first)
      assert_equal 'string', s.value_type.to_s
    end

    should 'not override global settings' do
      assert_raises(ArgumentError) do
        User.class_eval do
          setting_accessor :a_string, :type => :integer
        end
      end
    end

    should 'use value fallbacks' do
      assert_equal 'Oiski Poiski!', User.new.class_wise_with_value_fallback
    end

    should 'use default fallbacks' do
      assert_equal 'Kapitanski', User.new.class_wise_with_default_fallback
    end
  end

  context 'Boolean settings' do
    should 'respect temporary settings which are set to `false`' do
      user = User.new(:class_wise_truthy_boolean => false)
      assert_equal user.class_wise_truthy_boolean, false
    end

    should 'respect temporary settings which are set to `true`' do
      user = User.new(:a_boolean => true)
      assert_equal user.a_boolean, true
    end
  end
end
