class CreateProteins < ActiveRecord::Migration
  def change
    create_table :proteins do |t|
      t.string :accno
      t.string :desc
      t.string :species
      t.text :seq

      t.timestamps
    end

    add_index :proteins, :accno
    add_index :proteins, :species
  end
end
