rm(list = ls())

#### Set the Paths to the directories needed ####
wd <- getwd()
PathScripts <- file.path(wd, "scripts")
PathInput <- file.path(wd, "data")
PathOutput <- file.path(PathInput, "aqp_seq")

#### Load tehe packages ####
library("readxl")

#### Load the scripts ####
source(file = file.path(PathScripts, "fun.R"))

#### Load AQP information annd create a list of AQP per chromosome ####
AQP <- read_excel(path = file.path(PathInput, "1.reference-table-aqp-2021-02-08.xlsx"))[1:44,][-15,]
aqp_list <- split(AQP, f =  as.numeric(AQP$Chr_v5))

#### List the chromosome and order them in ascending order ####
path <- as.list(paste(file.path(PathInput, "B73_v5_per_chr"),list.files(path = file.path(PathInput, "B73_v5_per_chr"), pattern="chr*"), sep = "/"))
path <- path[c(1, 3, 4, 5, 6, 7, 8, 9, 10, 2)]

# Initialize and empty list
sequences <- list()

# For loop that goes through all the chromosomes and load the sequence and extract the gene sequence as well as the promoter sequence
# save everything in the object sequences + in txt files
for(i in seq_len(length(path))){
  print(i)
  tmp_aqp <- aqp_list[[i]]
  tmp_aqp <- split(tmp_aqp, f = tmp_aqp$Gene_Name)
  seq <- read.fasta(file = path[[i]], seqtype = "DNA")
  tmp_sequences <- lapply(tmp_aqp, get_promoter_seq, chromosome_seq = seq[[1]], path.output = PathOutput)
  sequences <- append(sequences, tmp_sequences)
}
