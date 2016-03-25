describe SettingAccessors::Configuration::GlobalSettingConfigurator do
  it 'initializes with a polymorphic type' do
    expect(SettingAccessors::Configuration::GlobalSettingConfigurator.new.type).to eql 'polymorphic'
  end

  describe '#validations' do

  end
end
