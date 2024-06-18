#!/bin/bash

accession_list="accession_list.txt" # Path to your accession list
n=4 # Number of cores to use


## Function to process each accession
process_accession() {

# Path to your s3 bucket where you want your fastq files to end up
s3_loc="s3://nao-harmon/test/raw"

local accession=$1
echo -e "\n Starting ${accession}\n"

echo "Prefetching SRA file"
prefetch $accession

echo "Converting SRA to FASTQ"
fastq-dump --split-3 --gzip $accession 

rm -rf ./$accession

# Move files to s3 bucket
echo "Moving forward/reverse read to s3 bucket"

aws s3 cp ./${accession}_1.fastq.gz ${s3_loc}/${accession}_1.fastq.gz
rm ./${accession}_1.fastq.gz

aws s3 cp ./${accession}_2.fastq.gz ${s3_loc}/${accession}_2.fastq.gz
rm ./${accession}_2.fastq.gz

}

export -f process_accession

## Run the process_accession function in parallel for each accession
parallel -j ${n} process_accession ::: $(cat $accession_list)
