class CreateTeachers < ActiveRecord::Migration[5.2]
  def change
    create_table :teachers do |t|
      t.string :vorname
      t.string :name
      t.string :number
      t.string :mail
      t.boolean :rec
      t.timestamps
    end
  end
end
