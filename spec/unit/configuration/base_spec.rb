describe SettingAccessors::Configuration::Base do

  #----------------------------------------------------------------
  #                        class_setting!
  #----------------------------------------------------------------

  describe '#class_setting!' do
    let(:options) { { :type => 'string', :default => 'I am a string!' } }

    subject(:class_settings) { SettingAccessors.configuration.send(:configuration_hash, :class_settings, :user) }

    before do
      SettingAccessors.configuration.class_setting!(User, :something, options)
    end

    it 'adds a new entry to the :class_settings hash' do
      is_expected.to have_key(:something)
    end

    it 'saves the given options in the correct configuration hash' do
      expect(class_settings[:something]).to eql options
    end
  end

  #----------------------------------------------------------------
  #                        class_setting
  #----------------------------------------------------------------

  describe '#class_setting' do
    let(:options) { { :type => 'string', :default => 'I am a string!' } }

    context 'when being asked for an existing class setting' do
      before do
        SettingAccessors.configuration.class_setting!(User, :something, options)
      end

      it 'returns the given options' do
        expect(SettingAccessors.configuration.class_setting(User, :something)).to have_attributes(options)
      end
    end

    context 'when being asked for a non-existent global setting' do
      it 'returns false' do
        expect(SettingAccessors.configuration.class_setting(User, :something)).to be_nil
      end
    end
  end
  
  #----------------------------------------------------------------
  #                        #global_setting!
  #----------------------------------------------------------------
  
  describe '#global_setting!' do
    it 'yields a setting configurator' do
      expect { |b| SettingAccessors.configuration.global_setting!(:name, &b) }.to yield_control
    end

    it 'adds a new entry to the :global_settings hash' do
      SettingAccessors.configuration.global_setting!(:something) {}
      expect(SettingAccessors.configuration.send(:configuration_hash, :global_settings)).to have_key(:something)
    end
  end

  #----------------------------------------------------------------
  #                        global_settings
  #----------------------------------------------------------------

  describe '#global_settings' do
    before do
      SettingAccessors.configuration.global_setting!(:something) {}
      SettingAccessors.configuration.global_setting!(:something_else) {}
    end

    subject { SettingAccessors.configuration.send(:configuration_hash, :global_settings) }

    it 'returns a hash with all globally defined settings' do
      is_expected.to have_key(:something)
      is_expected.to have_key(:something_else)
    end
  end
  
  #----------------------------------------------------------------
  #                       #global_setting?
  #----------------------------------------------------------------

  describe '#global_setting?' do
    context 'when being asked for an existing global setting' do
      before do
        SettingAccessors.configuration.global_setting!(:something)
      end

      it 'returns true' do
        expect(SettingAccessors.configuration.global_setting?(:something)).to be_truthy
      end
    end

    context 'when being asked for a non-existent global setting' do
      it 'returns false' do
        expect(SettingAccessors.configuration.global_setting?(:something)).to be_falsey
      end
    end
  end

  #----------------------------------------------------------------
  #                        #global_setting
  #----------------------------------------------------------------

  describe '#global_setting' do
    subject { SettingAccessors.configuration.global_setting(:something) }

    context 'when being asked for an existing global setting' do
      before do
        SettingAccessors.configuration.global_setting!(:something) do |setting|
          setting.type    = 'string'
          setting.default = 'I am a string!'
        end
      end

      it 'returns a hash containing the correct setting configuration' do
        is_expected.to have_attributes(:type => 'string', :default => 'I am a string!')
      end
    end

    context 'when being asked for a non-existent global setting' do
      it { is_expected.to be_nil }
    end
  end

  #----------------------------------------------------------------
  #                        #setting_class
  #----------------------------------------------------------------

  describe '#setting_class' do
    context 'when no specific value was set' do
      it 'returns the default value' do
        expect(SettingAccessors.configuration.setting_class).to eql Setting
      end
    end

    context 'when a specific value was set' do
      before do
        SettingAccessors.configure do |config|
          config.setting_class = String
        end
      end

      it 'returns this value' do
        expect(SettingAccessors.configuration.setting_class).to eql String
      end
    end
  end
end
