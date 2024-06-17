#!/bin/bash

# Path to your accession list
accession_list="accession_list.txt"
# Path to your s3 bucket where you want your fastq files to end up
s3_loc="s3://nao-harmon/test/raw"
# Number of cores to use
n=4

### Function to process each accession
process_accession() {

local accession=$1
echo -e "\n${accession}\n"

# Download the SRA file
prefetch $accession

# Convert SRA to FASTQ
fastq-dump --split-3 --gzip $accession && \
  pv ${accession}_1.fastq.gz | aws s3 cp - $s3_loc/${accession}_1.fastq.gz && \
  pv ${accession}_2.fastq.gz | aws s3 cp - $s3_loc/${accession}_2.fastq.gz

# Optionally, delete the SRA file to save space
rm -rf ./$accession
}

export -f process_accession

## Run the process_accession function in parallel for each accession
parallel -j ${n} process_accession ::: $(cat $accession_list)

