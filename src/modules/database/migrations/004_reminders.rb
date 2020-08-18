Sequel.migration do
  up do
    create_table(:reminders) do
      primary_key :id
      Integer :discord_id
      String :discord_name
      Text :message_content
      DateTime :message_date
    end
  end
end
