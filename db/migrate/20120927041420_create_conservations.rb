class CreateConservations < ActiveRecord::Migration
  def change
    create_table :conservations do |t|
      t.string :accno
      t.string :species
      t.integer :size
      t.string :chrom
      t.integer :genomic_start
      t.integer :genomic_stop
      t.string :strand
      t.text :seq

      t.timestamps
    end
    add_index :conservations, :accno
  end
end
