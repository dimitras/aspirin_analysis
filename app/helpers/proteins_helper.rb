module ProteinsHelper

	def seq_to_fasta_array(seq, pep_seq)
		wrapped = []
		index = 0
		highlighted_seq = ''
		bold_pep_seq = "<strong>#{pep_seq}</strong>".html_safe
		highlighted_seq = seq.gsub(pep_seq, bold_pep_seq).html_safe

		(0..seq.length-1).each do |i|
			if wrapped[index].nil?
				wrapped[index] = ''
			end

			wrapped[index] = wrapped[index] + seq[i..i]
			if ((i+1) % 60 == 0)
				index += 1
			end	
		end
		return wrapped
	end

	def find_peptide_in_protein()

	end

	def find_modification_in_protein()
		
	end



	def positions_of_peptide_in_protein(pep_seq, prot_seq)
		# return prot_seq.index(pep_seq)
	    positions = (0 .. prot_seq.length - 1).find_all { |i| prot_seq[i, pep_seq.length] == pep_seq }
	    puts positions
	    return positions
	end

	def letter_at_position(prot_seq, pos)
	    letter = prot_seq[pos..pos]
	    puts letter
	    return letter
	end

	def positions_of_pep_letter_in_protein(pep_seq, letter)
		letter_positions = []
		positions = positions_of_peptide_in_protein(pep_seq, prot_seq)
		letter_positions_in_seq = (0..seq.length - 1).find_all { |i| seq[i, 1] == letter }
		positions.each do |position|
			letter_positions_in_seq.each do |letter_position|
				letter_positions  << position + letter_position
			end
		end
		# puts seq.to_s + "\t:\t" + letter.to_s + "\t:\t" + letter_positions.to_s
		return letter_positions
	end

	def corresponding_letters_for_secondary_species(seq, letter, species_ids)
		letters = []
		positions = find_positions_for_seq_letter_in_ref_species(seq, letter)
		species_ids.each do |species_id|
			letters_by_species = ''
			positions.each do |position|
				if !@maf_entries.has_key?(species_id)
					letters_by_species << "NA"
				else
					letters_by_species << @maf_entries[species_id].letter_at_position(position).to_s + "(" + position.to_s + ")"
				end
			end
			letters << letters_by_species
		end
		return letters
	end
	
end
