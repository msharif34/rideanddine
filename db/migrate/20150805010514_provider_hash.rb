class ProviderHash < ActiveRecord::Migration
  def change
  	add_column :users, :provider_hash, :string
  end
end
