# == Schema Information
#
# Table name: conservations
#
#  id         :integer          not null, primary key
#  accno      :string(255)
#  desc       :string(255)
#  species    :string(255)
#  seq        :string(255)
#  protein_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Conservation < ActiveRecord::Base
  attr_accessible :accno, :chrom, :genomic_start, :genomic_stop, :seq, :size, :species, :strand

  belong_to :protein
end
