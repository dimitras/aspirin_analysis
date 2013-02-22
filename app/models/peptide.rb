# == Schema Information
#
# Table name: peptides
#
#  id           :integer          not null, primary key
#  pep_seq      :string(255)
#  rank_product :float
#  penalized_rp :float
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  cutoff       :float
#  experiment   :string(255)
#

class Peptide < ActiveRecord::Base
  # pagination default
  self.per_page = 50

  # accessible attributes for mass assignment
  attr_accessible :penalized_rp, :pep_seq, :rank_product, :cutoff, :experiment

  # default ordering for the model
  default_scope order("penalized_rp ASC")

  # define assosiations
  has_many :peptidepsms
  has_many :psms, :through => :peptidepsms, :order => 'psms.pep_score DESC'

  scope :filtered, lambda { |experiment, cutoff|
    where("peptides.experiment = ? AND peptides.cutoff = ?", experiment, cutoff)
  }
  
  scope :longer_than, lambda { |length|
    {
      :conditions => ["LENGTH(peptides.pep_seq) <= ?", length]
    }
  }

  scope :enzymed, lambda { |enzyme|
    {
      :include => :psms,
      :conditions => ["psms.enzyme = ?", enzyme]
    }
  }

  def summary_assigned_ions_for_top_peaks_count(n)
  	psm_counts = [0]*(n+1)
  	self.psms.each do |psm|
  		assigned_ions_for_top_peaks_count = psm.number_of_top_x_peaks_matching_assigned_ions(n)
  		psm_counts[assigned_ions_for_top_peaks_count] += 1
  	end
  	return psm_counts
  end

  def count_max_values()
	  max_values = []
	  self.psms.each do |psm|
		max_values << psm.max_ion_coordinates
	  end
	  
	  max_values_counts = {}
	  max_values.each do |value|
		max_value_str = value.join('|')
		if !max_values_counts.has_key? max_value_str
			max_values_counts[max_value_str] = 1
		else
			max_values_counts[max_value_str] += 1
		end
	  end
	  
	  return max_values_counts
  end

  def ions_array_with_max_intensities_counts(ion_type)
  	ions_hash = self.count_max_values
  	ions_table = Array.new
  	
  	#get the label from the type
  	label = ion_type[0..0]
  	for i in 0..self.psms[0].bions_array.length - 1
  		# fill the table with labels and nil for all yions' values
  		ions_table << ["#{label}(#{i+1})", 0, 0, 0, 0]
  	end
  	
  	ions_hash.each_key do |key|
  		(type, i, j) = key.split('|')
  		if type.to_s == ion_type.to_s
  			# fill the table with the counts of the most intense ions through spectrums
  			ions_table[i.to_i][j.to_i] = ions_hash[key]
  		end
  	end
  	
  	return ions_table
  end

  def ionstable_with_counting_max_intensities()
  	max_yions_array = ions_array_with_max_intensities_counts('yion')
  	max_bions_array = ions_array_with_max_intensities_counts('bion')
  	
  	ionstable = Array.new
  	aa = Array.new
  	y0 = Array.new
  	y1 = Array.new
  	y2 = Array.new
  	b0 = Array.new
  	b1 = Array.new
  	b2 = Array.new
  	for i in 0..max_yions_array.length - 1
  		aa[i] = pep_seq[i..i]

  		b0[i] = "b(#{i+1})"
  		b1[i] = max_bions_array[i][1]
  		b2[i] = max_bions_array[i][2]

  		y0[i] = "y(#{i+1})"
  		y1[i] = max_yions_array[i][1]
  		y2[i] = max_yions_array[i][2]
  	end

  	aa.push(pep_seq.last)
  	b0.push(nil)
  	b1.push(nil)
  	b2.push(nil)
  	y0.push(nil)
  	y1.push(nil)
  	y2.push(nil)
  	y0.reverse!
  	y1.reverse!
  	y2.reverse!
  	for i in 0..max_yions_array.length
  		ionstable[i] = [aa[i], b0[i], b1[i], b2[i], y0[i], y1[i], y2[i]]
  	end

  	return ionstable
  end

end
