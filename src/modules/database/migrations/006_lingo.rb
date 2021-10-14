Sequel.migration do
    up do
      create_table(:lingos) do
        primary_key :id
        DateTime :timestamp
        Integer :discord_id
        String :discord_name
        String :nick_name
        Integer :server_id
        String :dl_username
        Integer :xp, default: 0
        Integer :points, default: 0
        Integer :daily_time, default: 0
      end
    end
  
    down do
      drop_table(:lingo)
    end
  end
  