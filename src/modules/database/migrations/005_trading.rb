Sequel.migration do
    up do
      create_table(:traders) do
        primary_key :id
        DateTime :timestamp
        Integer :discord_id
        String :discord_name
        String :nick_name
        Integer :server_id
        Integer :money, default: 10000
        Integer :daily_time, default: 0
      end
  
      create_table(:trades) do
        primary_key :id
        DateTime :timestamp
        foreign_key :discord_id, :traders, on_delete: :cascade
        String :type
        String :symbol
        String :price
      end
    end
  
    down do
      drop_table(:traders)
      drop_table(:trades)
    end
  end
  