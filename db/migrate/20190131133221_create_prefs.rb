class CreatePrefs < ActiveRecord::Migration[5.2]
  def change
    create_table :prefs do |t|
      t.integer :time
      t.integer :req
      t.integer :free
      t.integer :mahn_count
      t.string  :pres_date
      t.boolean :login
      t.boolean :log_data
      t.timestamps
    end
  end
end
