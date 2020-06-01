Sequel.migration do
  up do
    create_table(:fmk_tags) do
      primary_key :id
      String :name, null: false
    end

    create_table(:fmk_options) do
      primary_key :id
      String :names, unique: true, null: false
      Integer :f1, default: 0
      Integer :m1, default: 0
      Integer :k1, default: 0
      Integer :f2, default: 0
      Integer :m2, default: 0
      Integer :k2, default: 0
      Integer :f3, default: 0
      Integer :m3, default: 0
      Integer :k3, default: 0
      foreign_key :fmk_tag_id, :fmk_tags, on_delete: :cascade
    end
  end
end
