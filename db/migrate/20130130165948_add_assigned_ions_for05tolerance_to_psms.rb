class AddAssignedIonsFor05toleranceToPsms < ActiveRecord::Migration
  def change
  	add_column :psms, :assigned_yions_with05tol_mzs_table, :binary
    add_column :psms, :assigned_yions_with05tol_intensities_table, :binary
    add_column :psms, :assigned_bions_with05tol_mzs_table, :binary
    add_column :psms, :assigned_bions_with05tol_intensities_table, :binary
  end
end
