# Aspirin Analysis Application
For visualization and review of mass spectrum peptide results.

This web application uses Mascot server's raw results data and reproduces the visualization for peptide spectrum matches. The database contains peptides filtered by Aspirin experiment, modification and peptide expectancy.


- Experiments: 	1. 3H Ace (only the acetylated ones),	2. Endogenous Ace


- Filtering the data
	- Isolate the peptides that are acetylated
	- Keep the unique peptides with the highest pep score
	- Find only the peptides with rank = 1
	- Filter by peptide expectancy cutoff: 0.05, 0.5, none (set to 10.0)
	- Set a score system calculating the rank product and penalized rp, which is rank product multiplied by 10 for the minus replicates. Lower RP means more significant.


** Extra analysis in sequence level, about conservation of the peptide modifications through different species. 


** For more details about the filtering and retrieving data, you may check this repository: https://github.com/dimitras/mascot-csv-filters