require 'rubygems'
require 'gnuplot'
# require 'hpricot'

class Psm < ActiveRecord::Base
	
	attr_accessible :accno, :cutoff, :genename, :mod, :pep_seq, :pep_score, :query, :rep, :mod_positions, :title, :charge, :rtinseconds, :mzs, :intensities, :peptide_id, :assigned_yions

	belongs_to :peptide
	has_many :proteins

	def mzs_array()
		array = Marshal::restore(mzs)
		puts array
		return array
	end
	
	def intensities_array()
		return Marshal::restore(intensities)
	end
	
	def assigned_yions_array()
		return Marshal::restore(assigned_yions)
	end
	
	# psm.peptide # => Peptide instance

	def plot_assigned_yions()
		filename = "public/figures/fig_#{rep}_#{query}_#{pep_seq}.png"
		unless File.exists? filename
			Gnuplot.open do |gp|
				Gnuplot::Plot.new( gp ) do |plot|
					plot.output filename
					plot.terminal 'png'
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
		filename
		# print("mspaint  #{%x{filename}}")
		# File.open(filename, 'rb') {|file| file.read } 
	end
end
