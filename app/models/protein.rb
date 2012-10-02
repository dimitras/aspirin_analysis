# == Schema Information
#
# Table name: proteins
#
#  id         :integer          not null, primary key
#  accno      :string(255)
#  desc       :string(255)
#  seq        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Protein < ActiveRecord::Base
  attr_accessible :accno, :desc, :seq, :species

  has_many :psms, :foreign_key => "accno", :primary_key => "accno"


	# def seq_to_fasta_array()
	# 	wrapped = []
	# 	index = 0
	# 	(0..self.seq.length-1).each do |i|
	# 		if wrapped[index].nil?
	# 			wrapped[index] = ''
	# 		end

	# 		wrapped[index] = wrapped[index] + self.seq[i..i]
	# 		if ((i+1) % 60 == 0)
	# 			index += 1
	# 		end
	# 	end
	# 	return wrapped
	# end
	
end



