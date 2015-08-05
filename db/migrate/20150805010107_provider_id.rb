class ProviderId < ActiveRecord::Migration

  def change
  	add_column :users, :provider_id, :string
  	add_column :users, :provider, :string
  end
end
