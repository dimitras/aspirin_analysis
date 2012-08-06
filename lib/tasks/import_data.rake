
namespace :db do

	require 'rubygems'
	require 'fastercsv'
	require 'pep'
	require 'mascot/dat'
	require 'gnuplot'

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

	# USAGE: rake db:load_psms_data --trace
	desc "Import hits csv to database using fastercsv"
	task :load_psms_data  => :environment do
		csvfile = ARGV[0]
		# REMEMBER TO uncomment the correct dataset (foldername)
		foldername = '../data/3H_Ace/'
		# foldername = '../data/Endogenous_Ace/'
		FasterCSV.foreach('joined_peps_005_cutoff.csv') do |row|
			assigned_ions = Array.new()
			if fieldnames.empty?
				fieldnames = row
			elsif !fieldnames.empty?
				peptide = row[22].to_s
				prot_accno = row[1].to_s
				prot_desc = row[2].to_s
				modification.clear
				if foldername.include? '3H_Ace'
					row[24].scan(/Acetyl:.+\(\d\)\s\((\w)\)/).each do |i| #Acetyl:2H(3) (K); 2 Acetyl:2H(3) (S)
						modification << $1
					end
					#get modification positions from string
					mod_positions_str = row[25].split('')
					mod_positions.clear
					mod_positions_str.each_index do |i|
						if !mod_positions_str[i].include?('0') && modification.include?(peptide.split('')[i])
							mod_positions << i + 1 #1-based
						end
					end
				elsif foldername.include? 'Endogenous_Ace'
					row[24].scan(/Acetyl\s\((\w)\)/).each do |i| # Acetyl (K)
						modification << $1
					end
					# get modification positions from string
					mod_positions_str = row[25].split('')
					mod_positions.clear
					mod_positions_str.each_index do |i|
						if !mod_positions_str[i].include?('0') && modification.include?(peptide.split('')[i])
							mod_positions << i + 1 #1-based
						end
					end
				end

				query_no = row[9].to_i
				parent_mass = row[14].to_f
				calc_mass = row[16].to_f
				delta = row[17].to_f
				cutoff = row[20].to_f
				pep_score = row[19].to_f
				replicate = row[27].split('/')[3].split('_')[1]

				# take the ions table from dat file
				filename = foldername + 'dats/' + replicate +  '.dat'
				dat = Mascot::DAT.open(filename, true)
				spectrum = dat.query(query_no)
				title = spectrum.title
				charge = spectrum.charge
				rtinseconds = spectrum.rtinseconds
				mzs = spectrum.mz
				intensities = spectrum.intensity

				# feed database with psms
				Psm.create(:accno => prot_accno,:cutoff => cutoff,:genename => "NA",:mod => modification,:pep => peptide,:pep_score => pep_score,:query => query_no,:rep => replicate,:mod_string => mod_positions,:title => title,:charge => charge,:rtinseconds => rtinseconds,:mzs => mzs,:intensities => intensities)
			end
		end
	end


	# USAGE: rake db:load_proteins_data --trace
	desc "Import proteins to database using fastercsv"
	task :load_proteins_data  => :environment do
		pfields = []
		pcols = []
		FasterCSV.foreach("data/") do |row|
			if pfields.empty?
				pfields = row
			else pfields.empty?
				pcols = row
				Protein.create(:accno => pcols[1], :desc => pcols[2], :seq => pcols[])
			end
		end
	end

	# USAGE: rake db:load_spectra_data --trace
	desc "Import spectra data to database using fastercsv"
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
