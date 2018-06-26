class AddSlackBotAccessTokenToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :slack_bot_access_token, :string
  end
end
