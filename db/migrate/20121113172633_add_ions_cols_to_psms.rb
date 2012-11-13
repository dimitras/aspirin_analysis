class AddIonsColsToPsms < ActiveRecord::Migration
  def change
    add_column :psms, :assigned_yions_mzs_table, :binary
    add_column :psms, :assigned_yions_intensities_table, :binary
    add_column :psms, :assigned_bions_mzs_table, :binary
    add_column :psms, :assigned_bions_intensities_table, :binary
    add_column :psms, :yions, :binary
    add_column :psms, :bions, :binary
  end
end
