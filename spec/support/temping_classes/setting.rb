Temping.create :setting do
  with_columns do |t|
    t.belongs_to :assignable, :polymorphic => true
    t.string :name
    t.text :value
    t.timestamps :null => true
  end

  belongs_to :assignable, :polymorphic => true
  include SettingAccessors::SettingScaffold

  def self.method_missing(method, *args)
    method_name = method.to_s

    if args.size > 1
      fail ArgumentError, 'Setting getters/setters accept at most one argument'
    end

    if method_name.last == '='
      self.create_or_update(method_name[0..-2], args.first, nil, true)
    else
      self.get(method_name, args.first)
    end
  end
end
