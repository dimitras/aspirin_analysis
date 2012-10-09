namespace :db do

	require 'rubygems'
	require 'fastercsv'
	require 'pep_dat'
	require 'mascot/dat'
	require 'fasta_parser'
	require 'maf_like_parser'
	require 'accno_to_refseq_translator'

	# ENDOGENOUS RESULTS-SETS #

	# USAGE: rake db:load_peptides_with_cutoff005_for_endogenous --trace
	desc "Import table csv data to database using fastercsv and feed with cutoff classifier = 0.05"
	task :load_peptides_with_cutoff005_for_endogenous  => :environment do
		foldername = 'data/En_ACE/'
		fields = []
		cols = []
		FasterCSV.foreach(foldername + "peps_by_rank_product_005_cutoff.csv") do |row|
			if fields.empty?
				fields = row
			else !fields.empty?
				cols = row
				Peptide.create(:pep_seq => cols[4],:rank_product => cols[18],:penalized_rp => cols[19], :cutoff => 0.05, :experiment => 'Endogenous-Acetylation')
			end
		end
	end

	# USAGE: rake db:load_peptides_with_cutoff05_for_endogenous --trace
	desc "Import table csv data to database using fastercsv and feed with cutoff classifier = 0.5"
	task :load_peptides_with_cutoff05_for_endogenous  => :environment do
		foldername = 'data/En_ACE/'
		fields = []
		cols = []
		FasterCSV.foreach(foldername + "peps_by_rank_product_05_cutoff.csv") do |row|
			if fields.empty?
				fields = row
			else !fields.empty?
				cols = row
				Peptide.create(:pep_seq => cols[4], :rank_product => cols[18], :penalized_rp => cols[19], :cutoff => 0.5, :experiment => 'Endogenous-Acetylation')
			end
		end
	end


	# USAGE: rake db:load_peptides_with_cutoff10_for_endogenous --trace
	desc "Import table csv data to database using fastercsv and feed with cutoff classifier = 10.0"
	task :load_peptides_with_cutoff10_for_endogenous  => :environment do
		foldername = 'data/En_ACE/'
		fields = []
		cols = []
		FasterCSV.foreach(foldername + "peps_by_rank_product_no_cutoff.csv") do |row|
			if fields.empty?
				fields = row
			else !fields.empty?
				cols = row
				Peptide.create(:pep_seq => cols[4], :rank_product => cols[18], :penalized_rp => cols[19], :cutoff => 10.0, :experiment => 'Endogenous-Acetylation')
			end
		end
	end




	# 3H-ACETYLATION RESULTS SETS#

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


	# USAGE: rake db:load_all_psms --trace
	desc "Import all hits csv to database using fastercsv"
	task :load_all_psms  => :environment do
		['data/3H_Ace/', 'data/En_ACE/'].each do |foldername|
			modification = []
			fieldnames = []
			mod_positions = []
			mod_positions_str = nil
			experiment = ''
			FasterCSV.foreach(foldername + 'joined_peps_no_cutoff.csv') do |row|
				if fieldnames.empty?
					fieldnames = row
				elsif !fieldnames.empty?
					peptide = row[22].to_s
					prot_accno = row[1].to_s
					prot_desc = row[2].to_s
					modification.clear
					if foldername.include? '3H_Ace'
						experiment = '3h-Acetylation'
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
					elsif foldername.include? 'En_ACE'
						experiment = 'Endogenous-Acetylation'
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

					# create new Pep and get the assigned yions
					pepl = Pep_dat.new(peptide, mzs, intensities, mod_positions)
					assigned_yions = pepl.assigned_yionstable
					serialized_assigned_yions = Marshal::dump(assigned_yions)

					# feed database with psms
					psm = Psm.create(:accno => prot_accno, :cutoff => cutoff, :mod => modification.join(','), :pep_seq => peptide, :pep_score => pep_score, :query => query_no, :rep => replicate, :mod_positions => mod_positions.join(','), :title => title, :charge => charge, :rtinseconds => rtinseconds, :mzs => serialized_mzs, :intensities => serialized_intensities, :assigned_yions => serialized_assigned_yions)

					# find all peptides
					peps = Peptide.where("cutoff >= ? AND pep_seq = ? AND experiment = ?" ,  psm.cutoff, peptide, experiment)

					peps.each do |pep|
						peptide_psm = Peptidepsm.create(:peptide_id => pep.id, :psm_id => psm.id)
						puts "PEPTIDE: " + pep.pep_seq.to_s + "\t" + pep.id.to_s + " PSM: " + psm.id.to_s + "\t" + psm.cutoff.to_s + " => " + peptide_psm.peptide_id.to_s  + "\t" + peptide_psm.psm_id.to_s
					end
				end
			end
		end
	end
	
	# # USAGE: rake db:populate_peptides_psms_join --trace
	# desc "Populate join table for peptides - psms"
	# task :populate_peptides_psms_join  => :environment do
	# 	Peptide.find_each do |pep|
	# 		pep_psms = Psm.where("cutoff <= ? AND pep_seq = ?" ,  pep.cutoff, pep.pep_seq)
	# 		pep.psm_ids = pep_psms.map{|psm| psm.id}
	# 		pep.update
	# 	end
	# end

	
	# USAGE: rake db:load_proteins --trace
	desc "Import all proteins info to database"
	task :load_proteins  => :environment do
		proteome_db_fasta_file = 'data/raw/HUMAN.2011_11.fasta'
		proteome_db_fap = FastaParser.open(proteome_db_fasta_file)
		
		proteome_db_fap.each do |fasta_entry|
			if fasta_entry.desc.include? 'GN='
				genename = fasta_entry.desc.split('GN=')[1].split(' ')[0]
			else
				genename = 'NA'
			end
			protein = Protein.create(:accno => fasta_entry.accno, :desc => fasta_entry.desc, :seq => fasta_entry.seq, :species => 'hg19', :genename => genename)
		end
	end

	
	# USAGE: rake db:update_psm_with_conservation_info --trace
	desc "Update psm with information for conservation"
	task :update_psm_with_conservation_info  => :environment do
		maf_file = 'data/raw/aln_nocutoff.maf'
		gene_from_accno_file = 'data/raw/accno2genenames.txt'
		mafp =  MAFlikeParser.open(maf_file)
		mrna_accno_from_gene_fp =  AccnoToRefseqTranslator.open(gene_from_accno_file)

		psms = Psm.all
		psms.each do |psm|
			pep_seq = psm.pep_seq
			genename = psm.protein.genename
			mod_letters = psm.mod_letters_array
			mod_positions = psm.mod_positions_array

			# find the entries with the genename that is connected to the psm in the translation file, and keep the entry tha contains the peptide
			maf_block = nil
			mod_positions_in_protein_array = []
			if mrna_accno_from_gene_fp.refseq_from_genename(genename) != nil
				mrna_accno_from_gene_fp.refseq_from_genename(genename).each do |entry|
					maf_block = mafp.maf_block_by_id(entry.accno)
					if maf_block != nil && maf_block.subseq_contained_in_ref_species?(pep_seq)
						mod_letters.each do |letter|
							mod_positions_in_protein_array << maf_block.find_positions_for_seq_letter_in_ref_species(pep_seq, mod_positions)
						end
						puts psm.id.to_s + " " + psm.accno.to_s + ' ' + pep_seq.to_s + ' ' + mod_positions.join(',') + " " + genename.to_s  + " " + maf_block.accno.to_s + " " + mod_positions_in_protein_array.join(',')
						psm_update = Psm.update(psm.id, { :mrna_id => maf_block.accno, :mod_positions_in_protein =>  mod_positions_in_protein_array.join(',') })
						break
					elsif maf_block == nil
						next
					end
				end
			end
		end
	end

	
	# USAGE: rake db:load_conservation_data --trace
	desc "Import conservation (maf) data to database"
	task :load_conservation_data  => :environment do
		maf_file = 'data/raw/aln_nocutoff.maf'
		mafp =  MAFlikeParser.open(maf_file)

		mafp.each do |maf_block|
			maf_block.maf_entries.each do |species, maf_entry|
				puts maf_entry.accno
				conservation = Conservation.create(:seq => maf_entry.seq,  :species => maf_entry.species, :mrna_id => maf_entry.accno)
			end
		end
	end
	
end
