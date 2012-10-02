module ProteinsHelper

	def seq_to_fasta_array(seq)
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
	
end
