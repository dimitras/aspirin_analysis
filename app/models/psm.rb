require 'pep'

class Psm < ActiveRecord::Base
	attr_accessible :accno, :cutoff, :genename, :mod, :pep_seq, :pep_score, :query, :rep, :mod_positions, :title, :charge, :rtinseconds, :mzs, :intensities

	def initialize()
		@pep = Pep.new(pep_seq, mod_positions, mzs, intensities)
	end
	
	def pep()
		return @pep
	end
	
	def intensities()
		return @pep.intensities
	end

	def mzs()
		return @pep.mzs
	end

	def assigned_yions()
		return @pep.assigned_yions
	end

	def title()
		return  @psm.title
	end
	
	def plot()
		filename = "#{figures_folder}/fig_#{repl_with_highest_score}_#{query_no}_#{pep_seq}.svg"
		Gnuplot.open do |gp|
			Gnuplot::Plot.new( gp ) do |plot|
				plot.output filename
				plot.terminal 'svg'
				plot.title  "#{title} - #{pep_seq}"
				plot.ylabel 'intensity'
				plot.xlabel 'm/z'
				x = assigned_ions.collect{|mass| mass.first}
				y = assigned_ions.collect{|arr| arr[1]}
				labels = assigned_ions.collect{|idx| idx[2]}

				plot.data << Gnuplot::DataSet.new( [mzs, intensities] ) do |ds|
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
end
