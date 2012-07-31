
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

	# PER PEPTIDE
	
	# USAGE: rake db:load_hits_data --trace
	desc "Import hits csv to database using fastercsv"
	task :load_hits_data  => :environment do
		mfields = []
		mcols = []
		FasterCSV.foreach("data/joined_peps_005_cutoff.csv") do |row|
			if mfields.empty?
				mfields = row
			else !mfields.empty?
				mcols = row
				Psm.create(:accno => mcols[1], :cutoff => mcols[20], :genename => mcols[] , :mod => mcols[24] , :pep => mcols[22], :pep_score => mcols[19], :query => mcols[9], :rep => mcols[27])
			end
		end
	end

	# USAGE: rake db:load_proteins_data --trace
	desc "Import proteins to database using fastercsv"
	task :load_proteins_data  => :environment do
		pfields = []
		pcols = []
		FasterCSV.foreach("data/joined_peps_005_cutoff.csv") do |row|
			if pfields.empty?
				pfields = row
			else pfields.empty?
				pcols = row
				Protein.create(:accno => pcols[1], :desc => pcols[2], :seq => pcols[])
			end
		end
	end

	# USAGE: rake db:load_spectra_data --trace
	desc "Import proteins to database using fastercsv"
	task :load_spectra_data  => :environment do
		sfields = []
		scols = []
		FasterCSV.foreach("data/") do |row|
			if sfields.empty?
				sfields = row
			else sfields.empty?
				scols = row
				Spectra.create(:ions1 => scols[], :query => scols[], :title => scols[])
			end
		end
	end
	
end
