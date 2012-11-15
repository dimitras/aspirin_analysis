# == Schema Information
#
# Table name: psms
#
#  id                                 :integer          not null, primary key
#  pep_seq                            :string(255)
#  query                              :string(255)
#  accno                              :string(255)
#  pep_score                          :float
#  rep                                :string(255)
#  mod                                :string(255)
#  cutoff                             :float
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  mod_positions                      :string(255)
#  title                              :string(255)
#  charge                             :string(255)
#  rtinseconds                        :string(255)
#  mzs                                :binary
#  intensities                        :binary
#  mrna_id                            :string(255)
#  mod_positions_in_protein           :string(255)
#  conserved_mod_positions_in_protein :string(255)
#  enzyme                             :text
#  assigned_yions_mzs_table           :binary
#  assigned_yions_intensities_table   :binary
#  assigned_bions_mzs_table           :binary
#  assigned_bions_intensities_table   :binary
#  yions                              :binary
#  bions                              :binary
#

require 'rubygems'
require 'gnuplot'

class Psm < ActiveRecord::Base
	
	attr_accessible :accno, :cutoff, :mod, :pep_seq, :pep_score, :query, :rep, :mod_positions, :title, :charge, :rtinseconds, :mzs, :intensities, :mrna_id, :mod_positions_in_protein, :enzyme, :assigned_yions_mzs_table, :assigned_yions_intensities_table, :assigned_bions_mzs_table, :assigned_bions_intensities_table, :yions, :bions

	has_many :peptidepsms
  	has_many :peptides, :through => :peptidepsms
	belongs_to :protein, :primary_key => "accno", :foreign_key => "accno"
	has_many :conservations, :primary_key => "mrna_id", :foreign_key => "mrna_id"

	# scope :enzymed, lambda { |enzyme|
	# 	where("enzyme = ?", enzyme)
	# }

	def mod_letters_array()
		return mod.split(/,/)
	end
	
	def mod_positions_array()
		return mod_positions.split(/,/)
	end

	def array_with_mod_positions_in_protein()
		return mod_positions_in_protein.split(/,/)
	end

	def mzs_array()
		return Marshal::restore(mzs)
	end
	
	def intensities_array()
		return Marshal::restore(intensities)
	end
	
	##########################################################
	# yions
	##########################################################

	def yions_array()
		return Marshal::restore(yions)
	end

	def assigned_yions_mzs_array()
		return Marshal::restore(assigned_yions_mzs_table)
	end

	def assigned_yions_intensities_array()
		return Marshal::restore(assigned_yions_intensities_table)
	end
	
	##########################################################
	# bions
	##########################################################

	def bions_array()
		return Marshal::restore(bions)
	end

	def assigned_bions_mzs_array()
		return Marshal::restore(assigned_bions_mzs_table)
	end

	def assigned_bions_intensities_array()
		return Marshal::restore(assigned_bions_intensities_table)
	end

	##########################################################
	# interface methods
	##########################################################

	def ionstable()
		ionstable = Array.new
		aa = Array.new
		y0 = Array.new
		y1 = Array.new
		y2 = Array.new
		b0 = Array.new
		b1 = Array.new
		b2 = Array.new
		for i in 0..bions_array.length - 1
			aa[i] = pep_seq[i..i]
			
			b0[i] = "b(#{i+1})"
			if assigned_bions_mzs_array[i][1]
				b1[i] = "#{bions_array[i][1]} (#{assigned_bions_mzs_array[i][1]} : #{assigned_bions_intensities_array[i][1]})"
			else
				b1[i] = bions_array[i][1]
			end

			if assigned_bions_mzs_array[i][2]
				b2[i] = "#{bions_array[i][2]} (#{assigned_bions_mzs_array[i][2]} : #{assigned_bions_intensities_array[i][2]})"
			else
				b2[i] = bions_array[i][2]
			end
			
			y0[i] = "y(#{i+1})"
			if assigned_yions_mzs_array[i][1]
				y1[i] = "#{yions_array[i][1]} (#{assigned_yions_mzs_array[i][1]} : #{assigned_yions_intensities_array[i][1]})"
			else
				y1[i] = yions_array[i][1]
			end

			if assigned_yions_mzs_array[i][2]
				y2[i] = "#{yions_array[i][2]} (#{assigned_yions_mzs_array[i][2]} : #{assigned_yions_intensities_array[i][2]})"
			else
				y2[i] = yions_array[i][2]
			end
		end

		aa.push(pep_seq.last)
		b0.push('')
		b1.push('')
		b2.push('')
		y0.push('')
		y1.push('')
		y2.push('')
		y0.reverse!
		y1.reverse!
		y2.reverse!
		for i in 0..bions_array.length
			ionstable[i] = [aa[i], b0[i], b1[i], b2[i], y0[i], y1[i], y2[i]]
		end
			
		
		return ionstable
	end

	def plot_assigned_ions_through_spectrum()
		figures_folder = "public/figures/"
		figure_filename = "fig_#{rep}_#{query}_#{pep_seq}.svg"
		filename = figures_folder + figure_filename
		
		unless File.exists? filename
			x = Array.new
			y = Array.new
			labels = Array.new
			bx = Array.new
			by = Array.new
			blabels = Array.new

			for i in 0..assigned_yions_mzs_array.length-1
				for j in 1..assigned_yions_mzs_array[i].length-1
					if assigned_yions_mzs_array[i][j]
						x.push(assigned_yions_mzs_array[i][j])
						y.push(assigned_yions_intensities_array[i][j])
						labels.push("y#{"+"*j}(#{i+1})")
					end

					if assigned_bions_mzs_array[i][j]
						bx.push(assigned_bions_mzs_array[i][j])
						by.push(assigned_bions_intensities_array[i][j])
						blabels.push("b#{"+"*j}(#{i+1})")
					end
				end
			end

			max_intensity = intensities_array.max
			
			Gnuplot.open do |gp|
				Gnuplot::Plot.new( gp ) do |plot|
					plot.output filename
					plot.terminal 'svg size 1100,500'
					plot.ylabel 'intensity'
					plot.xlabel 'm/z'
					plot.yrange "[0:#{max_intensity*1.4}]"
					# plot.title  "#{title} - #{pep_seq}"
					
					# spectrum plot
					plot.data << Gnuplot::DataSet.new( [mzs_array, intensities_array] ) do |ds|
						ds.with = 'impulses linecolor rgb "black"'
						ds.linewidth = 1
						ds.notitle
					end
					# yions plot
					plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
						ds.with = 'impulses linecolor rgb "red"'
						ds.linewidth = 1.5
						ds.notitle
					end
					# bions plot
					plot.data << Gnuplot::DataSet.new( [bx, by] ) do |ds|
						ds.with = 'impulses linecolor rgb "red"'
						ds.linewidth = 1.5
						ds.notitle
					end
					
					# y labels
					ylabels_pos = y.map{|value| max_intensity*1.05}
					plot.data << Gnuplot::DataSet.new( [x, ylabels_pos, labels] ) do |ds|
						ds.with = 'labels textcolor lt 1 rotate left font ",10"'
						ds.notitle
					end
# 					# b labels
					bylabels_pos = by.map{|value| max_intensity*1.2}
					plot.data << Gnuplot::DataSet.new( [bx, bylabels_pos, blabels] ) do |ds|
						ds.with = 'labels textcolor lt 1 rotate left font ",10"'
						ds.notitle
					end
				end
			end
		end
		return figure_filename
	end
end
