class CreatePresentations < ActiveRecord::Migration[5.2]
  def change
    create_table :presentations do |t|
      t.string :vorname
      t.string :name
      t.string :klasse
      t.string :titel
      t.string :fach
      t.string :betreuer
      t.string :zimmer
      t.string :von
      t.string :bis
      t.integer :frei
      t.integer :time
      t.timestamps
    end
  end
end
