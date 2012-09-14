namespace :db do

	require 'rubygems'
	require 'fastercsv'
	require 'pep_dat'
	require 'mascot/dat'

	# USAGE: rake db:load_peptides_with_cutoff005 --trace
	desc "Import table csv data to database using fastercsv"
	task :load_peptides_with_cutoff005  => :environment do
		foldername = 'data/3H_Ace/'
		fields = []
		cols = []
		FasterCSV.foreach(foldername + "peps_by_rank_product_005_cutoff.csv") do |row|
			if fields.empty?
				fields = row
			else !fields.empty?
				cols = row
				Peptide.create(:pep_seq => cols[4],:rank_product => cols[18],:penalized_rp => cols[19], :cutoff => 0.05, :experiment => '3h-Acetylation')
			end
		end
	end

	# USAGE: rake db:load_cutoff_classifier_005 --trace
	desc "Fill the cutoff column with cutoff classifier = 0.05 for all peptides of :load_pep_data"
	task :load_cutoff_classifier_005  => :environment do
		Peptide.update_all :cutoff => 0.05
	end


	# USAGE: rake db:load_peptides_with_cutoff05 --trace
	desc "Import table csv data to database using fastercsv and feed with cutoff classifier = 0.5"
	task :load_peptides_with_cutoff05  => :environment do
		foldername = 'data/3H_Ace/'
		fields = []
		cols = []
		FasterCSV.foreach(foldername + "peps_by_rank_product_05_cutoff.csv") do |row|
			if fields.empty?
				fields = row
			else !fields.empty?
				cols = row
				Peptide.create(:pep_seq => cols[4], :rank_product => cols[18], :penalized_rp => cols[19], :cutoff => 0.5, :experiment => '3h-Acetylation')
			end
		end
	end


	# USAGE: rake db:load_peptides_with_cutoff10 --trace
	desc "Import table csv data to database using fastercsv and feed with cutoff classifier = 10.0"
	task :load_peptides_with_cutoff10  => :environment do
		foldername = 'data/3H_Ace/'
		fields = []
		cols = []
		FasterCSV.foreach(foldername + "peps_by_rank_product_no_cutoff.csv") do |row|
			if fields.empty?
				fields = row
			else !fields.empty?
				cols = row
				Peptide.create(:pep_seq => cols[4], :rank_product => cols[18], :penalized_rp => cols[19], :cutoff => 10.0, :experiment => '3h-Acetylation')
			end
		end
	end


	# USAGE: rake db:load_all_hits --trace
	desc "Import all hits csv to database using fastercsv"
	task :load_all_hits  => :environment do
		# REMEMBER TO uncomment the correct dataset (foldername)
		foldername = 'data/3H_Ace/'
		# foldername = 'data/Endogenous_Ace/'
		modification = []
		fieldnames = []
		mod_positions = []
		mod_positions_str = nil
		FasterCSV.foreach(foldername + 'joined_peps_no_cutoff.csv') do |row|
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
					mod_positions_str = row[25].split('.')[1].split('')
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
					mod_positions_str = row[25].split('.')[1].split('')
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
				serialized_mzs = Marshal::dump(mzs)
				intensities = spectrum.intensity
				serialized_intensities = Marshal::dump(intensities)

				# find all peptides by pep_seq
				pep = Peptide.find_all_by_pep_seq(peptide)
				# psms = Peptide.psms()

				# create new Pep and get the assigned yions
				pepl = Pep_dat.new(peptide, mzs, intensities, mod_positions)
				assigned_yions = pepl.assigned_yionstable
				serialized_assigned_yions = Marshal::dump(assigned_yions)

				# feed database with psms
				psm = Psm.create(:accno => prot_accno, :cutoff => cutoff, :genename => 'NA', :mod => modification, :peptide_id => pep.id, :pep_seq => peptide, :pep_score => pep_score, :query => query_no, :rep => replicate, :mod_positions => mod_positions, :title => title, :charge => charge, :rtinseconds => rtinseconds, :mzs => serialized_mzs, :intensities => serialized_intensities, :assigned_yions => serialized_assigned_yions)
			end
		end
	end
	

	# # USAGE: rake db:load_proteins_data --trace
	# desc "Import proteins to database using fastercsv"
	# task :load_proteins_data  => :environment do
	# 	pfields = []
	# 	pcols = []
	# 	FasterCSV.foreach("data/") do |row|
	# 		if pfields.empty?
	# 			pfields = row
	# 		else pfields.empty?
	# 			pcols = row
	# 			Protein.create(:accno => pcols[1], :desc => pcols[2], :seq => pcols[])
	# 		end
	# 	end
	# end

	# # USAGE: rake db:load_spectra_data --trace
	# desc "Import spectra data to database using fastercsv"
	# task :load_spectra_data  => :environment do
	# 	sfields = []
	# 	scols = []
	# 	FasterCSV.foreach("data/") do |row|
	# 		if sfields.empty?
	# 			sfields = row
	# 		else sfields.empty?
	# 			scols = row
	# 			Spectra.create(:ions1 => scols[], :query => scols[], :title => scols[])
	# 		end
	# 	end
	# end

end
