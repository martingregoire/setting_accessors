Temping.create :user do
  with_columns do |t|
    t.string :name
    t.timestamps :null => true
  end
end
