#!/bin/bash

# Path to your accession list
accession_list="accession_list.txt"
# Path to your s3 bucket where you want your fastq files to end up
s3_loc="s3://nao-harmon/test/raw/"
# Number of cores to use
n=4

### Function to process each accession
process_accession() {

local accession=$1
echo -e "\n Starting ${accession}\n"

# Download the SRA file
echo "Prefetching SRA file"
prefetch $accession

# Convert SRA to FASTQ
echo "Converting SRA to FASTQ"
fastq-dump --split-3 --gzip $accession 

# Delete the SRA folder to save space
echo "Deleteing SRA folder"
rm -rf ./$accession

# Move files to s3 bucket
echo "Moving forward read to s3 bucket"
aws s3 cp ${accession}_1.fastq.gz ${s3_loc}/ 

echo "Moving reverse read to s3 bucket"
aws s3 cp ${accession}_2.fastq.gz ${s3_loc}/ 

}

export -f process_accession

## Run the process_accession function in parallel for each accession
parallel -j ${n} process_accession ::: $(cat $accession_list)
