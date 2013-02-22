require 'rubygems'

# # REMEMBER TO uncomment the correct modifications (MODS)
# # for 3H acetylation
# MODS = {
# 	'K' => 45.029395,
# 	'S' => 45.029395,
# 	'T' => 45.029395
# }
# # for endogenous
# # MODS = {
# #   'K' => 42.010565,
# #   'S' => 42.010565,
# #   'T' => 42.010565
# # }

# # masses taken from the dat file
# MW = {
# 	'A' => 71.037114 ,
# 	'R' => 156.101111,
# 	'N' => 114.042927,
# 	'D' => 115.026943,
# 	'C' => 160.030649,
# 	'E' => 129.042593,
# 	'Q' => 128.058578,
# 	'G' => 57.021464 ,
# 	'H' => 137.058912,
# 	'I' => 113.084064,
# 	'L' => 113.084064,
# 	'K' => 128.094963,
# 	'M' => 131.040485,
# 	'F' => 147.068414,
# 	'P' => 97.052764 ,
# 	'S' => 87.032028 ,
# 	'T' => 101.047679,
# 	'U' => 150.953630,
# 	'W' => 186.079313,
# 	'Y' => 163.063329,
# 	'V' => 99.068414,
# 	"K*" => 128.094963 + MODS['K'],
# 	"S*" => 87.032028 + MODS['S'],
# 	"T*" => 101.047679 + MODS['T']
# }

H = 1.007825
OH = 17.00274
H2O = 18.010565
NH3 = 17.026549


class Pep_dat
	attr_accessor :iontable, :bions, :yions, :seq, :mzs, :intensities, :mod_flag

	def initialize(seq, mzs, intensities, mod_flag, mods=[])
		@seq = seq.strip.upcase.split ""
		@mzs = mzs
		@intensities = intensities
		@mod_flag = mod_flag
		add_mods_to_pep_seq(mods)

		@iontable = []
		@bions = []
		@yions = []
		build_ions_tables()
	end

	##########################################
	# Some extra accessors
	##########################################
	def yions_pkmap() # pkmap: [[label, y, y++, y*, y0]...] each row corresponds to an mz from the spectrum
		if @yions_pkmap == nil
			@yions_pkmap = assign(@yions, 1.0)
		end
		return @yions_pkmap
	end
	
	def bions_pkmap() # pkmap: [[label, b, b++, b*, b0]...] each row corresponds to an mz from the spectrum
		if @bions_pkmap == nil
			@bions_pkmap = assign(@bions, 1.0)
		end
		return @bions_pkmap
	end

	def assigned_yions_mzs_table()
		if @assigned_yions_mzs_table == nil
			create_assigned_yions_mzs_and_intensities_table
		end
		return @assigned_yions_mzs_table
	end

	def assigned_yions_intensities_table()
		if @assigned_yions_intensities_table == nil
			create_assigned_yions_mzs_and_intensities_table
		end
		return @assigned_yions_intensities_table
	end

	def assigned_bions_mzs_table()
		if @assigned_bions_mzs_table == nil
			create_assigned_bions_mzs_and_intensities_table
		end
		return @assigned_bions_mzs_table
	end

	def assigned_bions_intensities_table()
		if @assigned_bions_intensities_table == nil
			create_assigned_bions_mzs_and_intensities_table
		end
		return @assigned_bions_intensities_table
	end

	##########################################
	# Interface methods
	##########################################
	# put methods that are exported from the class
	
	
	##########################################
	# Internal methods
	##########################################
	def create_assigned_yions_mzs_and_intensities_table()
		assigned_yions_mzs_table = Array.new
		assigned_yions_intensities_table = Array.new
		yions.each_index do |i|
			assigned_yions_mzs_table[i] = [yions[i][0], nil, nil, nil, nil]
			assigned_yions_intensities_table[i] = [yions[i][0], nil, nil, nil, nil]
		end

		yions_pkmap.each_index do |pkmap_i|
			pkmap_row = yions_pkmap[pkmap_i]

			if pkmap_row && pkmap_row[0]
				label = pkmap_row[0]
				for i in 1..pkmap_row.length-1
					if(pkmap_row[i] && pkmap_row[i] > 0)
						if assigned_yions_mzs_table[label-1][i]

							stored_dff = (assigned_yions_mzs_table[label-1][i] - yions[label-1][i]).abs
							new_dff = (mzs[pkmap_i] - yions[label-1][i]).abs
							if new_dff < stored_dff
								assigned_yions_mzs_table[label-1][i] = mzs[pkmap_i]
								assigned_yions_intensities_table[label-1][i] = intensities[pkmap_i]
							end
						else
							assigned_yions_mzs_table[label-1][i] = mzs[pkmap_i]
							assigned_yions_intensities_table[label-1][i] = intensities[pkmap_i]
						end
					end
				end
			end
		end

		@assigned_yions_mzs_table = assigned_yions_mzs_table
		@assigned_yions_intensities_table = assigned_yions_intensities_table
	end

	def create_assigned_bions_mzs_and_intensities_table()
		assigned_bions_mzs_table = Array.new
		assigned_bions_intensities_table = Array.new
		bions.each_index do |i|
			assigned_bions_mzs_table[i] = [bions[i][0], nil, nil, nil, nil]
			assigned_bions_intensities_table[i] = [bions[i][0], nil, nil, nil, nil]
		end

		bions_pkmap.each_index do |pkmap_i|
			pkmap_row = bions_pkmap[pkmap_i]

			if pkmap_row && pkmap_row[0]
				label = pkmap_row[0]
				for i in 1..pkmap_row.length-1
					if(pkmap_row[i] && pkmap_row[i] > 0)
						if assigned_bions_mzs_table[label-1][i]

							stored_dff = (assigned_bions_mzs_table[label-1][i] - bions[label-1][i]).abs
							new_dff = (mzs[pkmap_i] - bions[label-1][i]).abs
							if new_dff < stored_dff
								assigned_bions_mzs_table[label-1][i] = mzs[pkmap_i]
								assigned_bions_intensities_table[label-1][i] = intensities[pkmap_i]
							end
						else
							assigned_bions_mzs_table[label-1][i] = mzs[pkmap_i]
							assigned_bions_intensities_table[label-1][i] = intensities[pkmap_i]
						end
					end
				end
			end
		end

		@assigned_bions_mzs_table = assigned_bions_mzs_table
		@assigned_bions_intensities_table = assigned_bions_intensities_table
	end
	
	def build_ions_tables()
		@seq.each_index do |i|
			idx = i + 1
			b = y = [nil]*5

			#Bions
			unless i == @seq.length - 1
				tmp = @seq[0..i]
				b  = calc_ion_mz_table(tmp)
				@bions.push(b)
			end

			# Yions
			unless i == 0
				tmp = @seq[i..-1]
				y  = calc_ion_mz_table(tmp,false)
				@yions.unshift(y)
			end

			@iontable<<[@seq[i], idx, @seq.length - i , b, y]
		end
	end

	# Grab legitimate y ions and rank them in intensity desc
	def ranked_yions_intensities_idx()
		ranked_idx = []
		idxset = []
		intset=[]
		yions_pkmap.each_index do |i|
                        # puts i.to_s + '\t' + yions_pkmap.join(",")
                        if yions_pkmap[i] && yions_pkmap[i][0] && !yions_pkmap[i][1].nil? && yions_pkmap[i][1] > 0
				idxset.push(i)
				intset.push(intensities[i])
			end
		end
		intset.each do
			maxi = intset.index(intset.max())
			ranked_idx.push( idxset[maxi] )
			intset[maxi] = 0
		end
		return ranked_idx
	end
	
	# Grab legitimate b ions and rank them in intensity desc
	def ranked_bions_intensities_idx()
		ranked_idx = []
		idxset = []
		intset=[]
		bions_pkmap.each_index do |i|
            if bions_pkmap[i] && bions_pkmap[i][0] && !bions_pkmap[i][1].nil? && bions_pkmap[i][1] > 0
				idxset.push(i)
				intset.push(intensities[i])
			end
		end
		intset.each do
			maxi = intset.index(intset.max())
			ranked_idx.push( idxset[maxi] )
			intset[maxi] = 0
		end
		return ranked_idx
	end
	
	def add_mods_to_pep_seq(mods)
		mods.each do |m|
			@seq[m.to_i - 1] += "*"
		end
	end

	def calc_mw(seq=[])
		mw = 0.0
		seq.each do |aa|
			mw += mws[aa]
		end
		return mw
	end

	def mw(charge=0)
		return calc_mw(@seq) + H2O + (H * charge)
	end

	def calc_ion_mz_table(seq,nterm=true)
		tmw = 0.0
		if !nterm
			tmw = H + OH
		end
		# ions = [seq, mh, mhh, mh-nh3 , mh-h20]
		ions = [seq.join(""), (calc_mw(seq) + tmw + H )]
		ions << ( ions[1] +  H ) / 2
		# need R,N or Q for immonium ions
		if seq.join("").match(/[RNQ]/)
			ions << ions[1] - NH3
		else
			ions << nil
		end
		# Need S or T for water losses
		if seq.join("").match(/[ST]/)
			ions << ions[1] - H2O
		else
			ions << nil
		end
		return ions
	end
	
	# Assigns the ion table to a given mass spectrum, walking through the m/z and ion series arrays to assign the ions to a mass peaks, given a tolerance
	# Returns a map of peaks that have ions assigned to them
	# http://174.129.8.134/mascot/help/results_help.html#PEP
	# example: http://174.129.8.134/mascot/cgi/peptide_view.pl?from=100&to=800&_label_all=0&file=..%2Fdata%2F20120323%2FF001507.dat&query=20052&hit=1&section=5&ave_thresh=38&_ignoreionsscorebelow=0&report=0&_sigthreshold=0.05&_msresflags=3138&_msresflags2=10&percolate=0&percolate_rt=0&tick1=100&tick_int=50&range=700&index=B4DHQ2&px=1
	# http://174.129.8.134/mascot/cgi/peptide_view.pl?from=0&to=0&Reset=Full+range&_label_all=0&file=..%2Fdata%2F20120323%2FF001507.dat&query=40008&hit=1&section=5&ave_thresh=38&_ignoreionsscorebelow=0&report=0&_sigthreshold=0.05&_msresflags=3138&_msresflags2=10&percolate=0&percolate_rt=0&tick1=220&tick_int=20&range=360&index=B4DS57&px=1
	def assign(ions,tol=0.5) # changed tolerance from 1.0 to 0.5
		# ion is [idx,b,b++,b*,b0] or y
		pkmap = Array.new(mzs.length)
		i1 = i2 =  0

		# traverse through ios series looking for matches
		while i1 < mzs.length && i2 < ions.length
			# don't have a mass to look for. next ion
			unless ions[i2][1]
				i2 += 1
				next
			end
			# x = [idx,+,++,*,0]
			x = [nil]*5
			dff = mzs[i1] - ions[i2][1]
            # puts [i1, i2, mzs[i1], ions[i2][1], dff].join("\t")
                        
			if dff > tol
				# mass is too large, get next ion
				pkmap[i1] = x
				i2 += 1
			elsif dff <  0 - tol
				# mass is too small for the + ion
				# checking other ions
				# ++ # must check for these outside of this method
				# immonium ions
				if ions[i2][3] && ((mzs[i1] - ions[i2][3]).abs <= tol) && !((mzs[i1] - ions[i2][3]).abs > tol)
					x[0]=  i2 + 1
					x[3] = ions[i2][3]
				end
				# water loss
				if ions[i2][4] && !((mzs[i1] - ions[i2][4]).abs <= tol) && !((mzs[i1] - ions[i2][4]).abs > tol)
                                        x[0]=  i2 + 1
                                        x[4] = ions[i2][4]
				end
				# mass is too small, advance
				pkmap[i1] = x
				i1 += 1
                        else
                                # set the index
                                x[0] = i2  + 1
                                x[1] = ions[i2][1]
                                pkmap[i1] = x
                                i1 += 1
                        end
		end
		# recheck  spectra for ++ daughter ions
		i1 = i2 =  0
		while i1 < mzs.length && i2 < ions.length
			unless ions[i2][2]
				i2 += 1
				next
			end
			dff = mzs[i1] - ions[i2][2]
			if dff > tol
				# mass is too large
				i2 += 1
				next
			elsif dff.abs() <= tol
				pkmap[i1][0] = i2+1
				pkmap[i1][2] = ions[i2][2]
			end
			i1 += 1
		end
		return pkmap
	end

	def to_s
		inspect
	end

	def inspect
		@seq.join("")
	end
end


# amino acid and modification masses taken from dat file #

def mods(flag)
	if flag == "3h-Acetylation"
		return {
			'K' => 45.029395,
			'S' => 45.029395,
			'T' => 45.029395
		}
	elsif flag == "Endogenous-Acetylation"
		return {
			'K' => 42.010565,
			'S' => 42.010565,
			'T' => 42.010565
		}
	end
end

def mws()
	return {
		'A' => 71.037114 ,
		'R' => 156.101111,
		'N' => 114.042927,
		'D' => 115.026943,
		'C' => 160.030649,
		'E' => 129.042593,
		'Q' => 128.058578,
		'G' => 57.021464 ,
		'H' => 137.058912,
		'I' => 113.084064,
		'L' => 113.084064,
		'K' => 128.094963,
		'M' => 131.040485,
		'F' => 147.068414,
		'P' => 97.052764 ,
		'S' => 87.032028 ,
		'T' => 101.047679,
		'U' => 150.953630,
		'W' => 186.079313,
		'Y' => 163.063329,
		'V' => 99.068414,
		"K*" => 128.094963 + mods(mod_flag)['K'],
		"S*" => 87.032028 + mods(mod_flag)['S'],
		"T*" => 101.047679 + mods(mod_flag)['T']
	}
end


########################################################
# TODO DELETE THE FOLLOWING 11/12/2012
########################################################

#### CREATING ALL Y/B-IONS TABLES ####

# 	# get mass-intensity values for all yions and label(index) for the assigned ones
# 	def all_yionstable()
# 		all_yions = Array.new
# 		for i in 0..mzs.length-1
# 			if assigned_yions_table.include?(mzs[i].to_f)
# 				all_yions << [mzs[i], intensities[i], "y(#{yions_pkmap[i][0]})"]
# 			else
# 				all_yions << [mzs[i], intensities[i], '']
# 			end
# 		end
# 		return all_yions
# 	end
#
# 	# get mass-intensity values for all bions and label(index) for the assigned ones
# 	def all_bionstable()
# 		all_bions = Array.new
# 		for i in 0..mzs.length-1
# 			if assigned_bions_table.include?(mzs[i].to_f)
# 				all_bions << [mzs[i], intensities[i], "b(#{bions_pkmap[i][0]})"]
# 			else
# 				all_bions << [mzs[i], intensities[i], '']
# 			end
# 		end
# 		return all_bions
# 	end