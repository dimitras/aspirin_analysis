# == Schema Information
#
# Table name: psms
#
#  id             :integer          not null, primary key
#  pep_seq        :string(255)
#  query          :string(255)
#  accno          :string(255)
#  pep_score      :float
#  rep            :string(255)
#  mod            :string(255)
#  genename       :string(255)
#  cutoff         :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  mod_positions  :string(255)
#  title          :string(255)
#  charge         :string(255)
#  rtinseconds    :string(255)
#  mzs            :binary
#  intensities    :binary
#  assigned_yions :binary
#

require 'rubygems'
require 'gnuplot'
# require 'hpricot'

class Psm < ActiveRecord::Base
	
	attr_accessible :accno, :cutoff, :genename, :mod, :pep_seq, :pep_score, :query, :rep, :mod_positions, :title, :charge, :rtinseconds, :mzs, :intensities, :assigned_yions

	has_many :peptidepsms
  	has_many :peptides, :through => :peptidepsms
	# has_and_belongs_to_many :peptides#, :foreign_key => "pep_seq"#peptide_id"
	has_and_belongs_to_many :proteins

	def mzs_array()
		return Marshal::restore(mzs)
	end
	
	def intensities_array()
		return Marshal::restore(intensities)
	end
	
	def assigned_yions_array()
		return Marshal::restore(assigned_yions)
	end

	def plot_assigned_yions()
		figures_folder = "public/figures/"
		figure_filename = "fig_#{rep}_#{query}_#{pep_seq}.svg"
		filename = figures_folder + figure_filename
		unless File.exists? filename
			Gnuplot.open do |gp|
				Gnuplot::Plot.new( gp ) do |plot|
					plot.output filename
					plot.terminal 'svg'
					plot.title  "#{title} - #{pep_seq}"
					plot.ylabel 'intensity'
					plot.xlabel 'm/z'
					x = assigned_yions_array.collect{|mass| mass.first}
					y = assigned_yions_array.collect{|arr| arr[1]}
					labels = assigned_yions_array.collect{|idx| idx[2]}

					plot.data << Gnuplot::DataSet.new( [mzs_array, intensities_array] ) do |ds|
						ds.with = 'impulses linecolor rgb "blue"'
						ds.linewidth = 1
						ds.notitle
					end

					plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
						ds.with = 'impulses linecolor rgb "red"'
						ds.linewidth = 1.5
						ds.notitle
					end

					ymax = y.max
					ylabels_pos = y.map{|value| value + ymax*0.05}
					plot.data << Gnuplot::DataSet.new( [x, ylabels_pos, labels] ) do |ds|
						ds.with = 'labels textcolor lt 1 rotate left'
						ds.notitle
					end
				end
			end
		end
		return figure_filename
		# print("mspaint  #{%x{filename}}")
		# File.open(filename, 'rb') {|file| file.read } 
	end
end
