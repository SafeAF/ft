class AddLastIpAddressToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_ip_address, :string
  end
end
