# USAGE: rake db:load_pep_data --trace
namespace :db do
	desc "Import table csv data to database using fastercsv"
	task :load_pep_data  => :environment do
		require 'rubygems'
		require 'fastercsv'
		fields = []
		cols = []
		FasterCSV.foreach("data/peps_by_rank_product_005_cutoff.csv") do |row|
			if fields.empty?
				fields = row
			else !fields.empty?
				cols = row
				Peptide.create(:pep_seq => cols[4],:rank_product => cols[18],:penalized_rp => cols[19])
			end
		end
	end
end
