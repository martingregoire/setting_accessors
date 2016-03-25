require 'generator_spec'
require 'generators/setting_accessors/install_generator'
$destination = SettingAccessors.root.join('tmp')

describe SettingAccessors::Generators::InstallGenerator, type: :generator do
  destination $destination
  arguments %w(model_name)

  before(:all) do
    prepare_destination
    run_generator(['--model_name Setting'])
  end

  it 'creates the initializer file' do
    expect(File).to exist $destination.join('config/initializers/setting_accessors.rb')
  end

  it 'creates the model file' do
    expect(File).to exist $destination.join('app/models/setting.rb')
  end

  it 'generates a migration file' do
    expect(Dir[$destination.join('db/migrate/*_create_settings.rb')]).to have(1).item
  end
end
