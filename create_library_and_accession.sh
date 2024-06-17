#!/bin/bash
#
# Path to SRA run table
metadata_file='./sraruntable.csv'
library_csv='./library.csv'
acc_file='./accession_list.txt'

# Create library.csv file
echo "library,sample " > ${library_csv}

# Assumes SSR is in the first column, and assign sample and library to be same
cut -d',' -f1 ${metadata_file} | tail -n +2 | awk '{print $1","$1}' >> ${library_csv}

# Creates accession list to download data
cut -d',' -f1  ${library_csv} | tail -n +2 > ${acc_file}

