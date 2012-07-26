class CreateProteins < ActiveRecord::Migration
  def change
    create_table :proteins do |t|
      t.string :accno
      t.string :desc
      t.string :seq

      t.timestamps
    end
  end
end
