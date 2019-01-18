class CreateAdmins < ActiveRecord::Migration[5.2]
  def change
    create_table :admins do |t|
      t.string :handle
      t.string :password_digest

      t.timestamps
    end
    add_index :admins, :handle, unique: true
  end
end
