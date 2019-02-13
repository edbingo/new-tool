class CreatePrefs < ActiveRecord::Migration[5.2]
  def change
    create_table :prefs do |t|
      t.integer :time
      t.integer :req
      t.integer :free
      t.boolean :login
      t.timestamps
    end
  end
end
