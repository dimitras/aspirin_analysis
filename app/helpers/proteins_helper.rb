module ProteinsHelper

	# wrap protein sequence to fasta
	def seq_to_fasta_array(seq, pep_seq)
		wrapped = []
		index = 0

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

	# highlight the peptide through the protein and the modifications through the peptide
	def highlight_seq(seq, pep_seq, mod_positions)
		mod_positions = [2,5]

		pep_seq_split = pep_seq.split("")
		mod_positions.each do |mod_position|
			pep_seq_split[mod_position] = "<span id='highlight_modification'>#{pep_seq_split[mod_position]}</span>"
		end
		mod_highlighted_pep_seq = pep_seq_split.join()
		puts mod_highlighted_pep_seq
			
		bold_pep_seq = "<span id='highlight_peptide'>#{mod_highlighted_pep_seq}</span>"
		seq.gsub!(pep_seq, bold_pep_seq)
		return seq.html_safe
	end
	
end
