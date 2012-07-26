class CreateSpectras < ActiveRecord::Migration
  def change
    create_table :spectras do |t|
      t.string :query
      t.string :title
      t.string :ions1

      t.timestamps
    end
  end
end
