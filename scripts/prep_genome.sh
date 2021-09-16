# To separate your genome per chromosome: 
# install the python package pyfaidx with pip install pyfaidx 
# find the path to the executable 
# find in the directory where your genome is stored (here the example is the B73 genome version 5)
# go in the directory you want your results 
# launch the code:

faidx -x /media/maxlaurent/Elements/genome_databases/B73_v5/Zm-B73-REFERENCE-NAM-5.0.fa
# To remove the scaffolds
rm scaf*

# After that, you get on fasta file per chromosome