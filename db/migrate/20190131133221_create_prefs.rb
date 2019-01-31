class CreatePrefs < ActiveRecord::Migration[5.2]
  def change
    create_table :prefs do |t|
      t.boolean :time
      t.boolean :req
      t.timestamps
    end
  end
end
