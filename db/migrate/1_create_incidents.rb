Sequel.migration do
  up do
    create_table(:incidents) do
      primary_key :id
      Integer :red
      Integer :orange     
      Integer :blue
      Integer :green  
      Integer :yellow
      Integer :silver  
      DateTime :created_at, :null=>false
    end
  end

  down do
    drop_table(:incidents)
  end
end