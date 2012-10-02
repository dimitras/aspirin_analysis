class CreateConservations < ActiveRecord::Migration
  def change
    create_table :conservations do |t|
      t.string :primary_species_accno
      t.string :mrna_id
      t.string :species
      t.text :seq

      t.timestamps
    end
    add_index :conservations, :primary_species_accno
  end
end
