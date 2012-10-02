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

  has_many :peptidepsms
  has_many :psms, :through => :peptidepsms
  # has_and_belongs_to_many :psms#, :foreign_key => "pep_seq", :primary_key => "pep_seq"
  
# scope :fdr, lambda{|c|  joins(:psms).where("psms.cutoff" <= c)}
# scope :filtered_psms, joins(:psms).where("psms.cutoff <= ?" ,  0.05)
  
end
