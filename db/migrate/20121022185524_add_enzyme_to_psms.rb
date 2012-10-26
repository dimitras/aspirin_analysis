class AddEnzymeToPsms < ActiveRecord::Migration
  def change
    add_column :psms, :enzyme, :text
  end
end
