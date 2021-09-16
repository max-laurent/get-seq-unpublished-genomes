# Loading the packages required
library("seqinr")
library("tidyverse")

#' Extract the promoter and the gene sequence
#'
#' @param data Data frame containing the information about the gene you want to retrieve the sequences
#' @param gene_name_id
#' @param start_id String indicating in which column to find the starting position of the gene
#' @param stop_id String indicating in which column to find the ending position of the gene
#' @param wanted_length Length of the promoter, by default set to 4500
#' @param chromosome_seq fasta sequence of the chromosome your gene is in. Comes from seqinr::read.fasta
#'
#' @return a list containing the gene sequence and the promoter sequence. When the gene is on the complementary strand, the promoter is at the second position in the list
#' @export
#' @author Maxime Laurent
#'
#' @examples
#' get_promoter_seq(AQP1, chromosome_seq[[1]])
get_promoter_seq <- function(data, gene_name_id = "Gene_Name", start_id = "ChrStart_v5", stop_id = "ChrStop_v5", wanted_length = 4500, chromosome_seq, path.output = NULL){
  
  # Extract the position of the gene
  genestart <- data %>% select(.data[[start_id]]) %>% unlist() %>% as.numeric()
  genestop <- data %>% select(.data[[stop_id]]) %>% unlist() %>% as.numeric()
  
  gene_name <- data %>% select(.data[[gene_name_id]]) %>% unlist() 
  
  if(genestart > genestop){
    
    # Calculate the position of the promoter
    prom_start <- genestart + 1
    prom_stop <- genestart + 1 + wanted_length
    
    # Retrieve the dna sequences of the gene and the promoter
    gene_seq <- paste(chromosome_seq[genestop:genestart], collapse = "")
    promoter <- paste(chromosome_seq[prom_start:prom_stop], collapse = "")
    return(list(Gene_seq = gene_seq, Promoter_seq = promoter))
    if(!is.null(path.output)){
      write.fasta(list(Gene_seq = gene_seq, Promoter_seq = promoter), names = c(gene_name, paste(gene_name, "promoter", sep ="_")),file.out = paste0(path.output, "/prom_gene_sequences_", gene_name,".txt"))
    }
    
  } else {
    
    # Calculate the position of the promoter
    prom_start <- genestart - 1 - wanted_length
    prom_stop <- genestart - 1
    
    # Retrieve the dna sequences of the gene and the promoter
    gene_seq <- paste(chromosome_seq[genestart:genestop], collapse = "")
    promoter <- paste(chromosome_seq[prom_start:prom_stop], collapse = "")
    return(list(Promoter_seq = promoter, Gene_seq = gene_seq))
    if(!is.null(path.output)){
      write.fasta(list(Promoter_seq = promoter, Gene_seq = gene_seq), names = c(paste(gene_name, "promoter", sep ="_"), gene_name),file.out = paste0(path.output, "/prom_gene_sequences_", gene_name,".txt"))
    }
  }
  # If no output file is provided, the data will be returned in the console
  # If an output file is provided, the data is saved in rds

}

