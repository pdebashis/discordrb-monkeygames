Sequel.migration do
  up do
    create_table(:fmk_options) do
      primary_key :id
      String :tag, null: false
      String :options, unique: true, null: false
      Integer :f1, default: 0
      Integer :m1, default: 0
      Integer :k1, default: 0
      Integer :f2, default: 0
      Integer :m2, default: 0
      Integer :k2, default: 0
      Integer :f3, default: 0
      Integer :m3, default: 0
      Integer :k3, default: 0
    end
  end
end
