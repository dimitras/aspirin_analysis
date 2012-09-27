# == Schema Information
#
# Table name: spectras
#
#  id         :integer          not null, primary key
#  query      :string(255)
#  title      :string(255)
#  ions1      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Spectra < ActiveRecord::Base
  attr_accessible :ions1, :query, :title
end
