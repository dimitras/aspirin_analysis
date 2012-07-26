
namespace :db do

	require 'rubygems'
	require 'fastercsv'

	# USAGE: rake db:load_pep_data --trace
	desc "Import table csv data to database using fastercsv"
	task :load_pep_data  => :environment do
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

	desc "Import hits csv to database using fastercsv"
	task :load_hits_data  => :environment do
		mfields = []
		mcols = []
		FasterCSV.foreach("data/joined_peps_005_cutoff.csv") do |row|
			if mfields.empty?
				mfields = row
			else !mfields.empty?
				mcols = row
				Psm.create(:accno => mcols[1], :cutoff => , :genename => mcols[3] , :mod => mcols[32] , :pep => mcols[4], :pep_score => mcols[31], :query => mcols[0], :rep => mcols[])
			end
		end
	end
end
