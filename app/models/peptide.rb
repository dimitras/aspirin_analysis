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

require 'psm'

class Peptide < ActiveRecord::Base
  # pagination default
  self.per_page = 50
  # accessible attributes for mass assignment
  attr_accessible :penalized_rp, :pep_seq, :rank_product, :cutoff, :experiment

  # default ordering for the model
  default_scope order("penalized_rp ASC")

  # The following method does not allow you to take 
  # advantage of Rails associations. Use the following instead:
  #
  has_many :peptidepsms
  has_many :psms, :through => :peptidepsms
  # has_and_belongs_to_many :psms#, :foreign_key => "pep_seq", :primary_key => "pep_seq"
  has_and_belongs_to_many :proteins

  # @peptide = @psm.peptide
  # # @psm = @peptide.psms
  # 
  # you will need to work out how to join the tables on load via the IDs

#   def psms()
# 	  # return Psm.find_all_by_pep_seq(pep_seq)
#     return Psm.where(:cutoff => 0..cutoff).find_all_by_pep_seq(pep_seq)
#   end
  
  # scope :fdr_05, joins(:psms).where("psms.cutoff" <= 0.05)
  # scope :fdr, lambda{|c|  joins(:psms).where("psms.cutoff" <= c)}
  # scope :filtered_psms, lambda{ joins(:psms).where('psms.cutoff' => 0..params[:cutoff])}
  # scope :filtered_psms, joins(:psms).where("psms.cutoff <= ?" ,  0.05)
  
end
