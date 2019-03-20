class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.string :name
      t.string :vorname
      t.string :number
      t.string :mail
      t.string :klasse
      t.string :code
      t.string :password_digest
      t.boolean :register
      t.boolean :rec
      t.text :select

      t.timestamps
    end
    add_index :students, :number, unique: true
  end
end
