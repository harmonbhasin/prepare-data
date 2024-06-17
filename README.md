# Prepare data for [Will's v2 Pipeline](https://github.com/naobservatory/mgs-workflow)

Here's what to do!

## Pre-requisties
1. AWS Batch on EC2 instance will be the most fast way to analyze the dataset, see [here](https://data.securebio.org/wills-public-notebook/notebooks/2024-06-11_batch.html).
2. SRAtoolkit is needed to download your dataset. You can either download from [here](https://github.com/ncbi/sra-tools/wiki/01.-Downloading-SRA-Toolkit) or just run `./setup-yum.sh` (this is the option labeled `Cloud - yum install script` on the tutorial).

## Instructions
1. Go [NCBI](https://www.ncbi.nlm.nih.gov/), enter your Bioproject, and go to the dataset.
2. Click on "SRA" under 'Related information' on the right side of the page.
3. You should see a pop-up above 'Links from BioProject in the center, that says "View results as an expanded interactive table using the RunSelector. Send results to RunSelector". Click on "Send to RunSelector".
4. You should see a table with all the runs. Click the button labeled "Metadata" to download all the metadata (this should be called something like `SraRunTable.csv`). Then copy it to your machine using scp (for example, `scp -i [location to your key] ~/Downloads/SraRunTable.csv [ec2 instance name]:/home/ec2-user/`).
5. Run `./create_library_and_accession.sh` to create `library.csv` (note we're using SRA for both library and sample) and `accession_list.txt` (this is used to download dataset).
6. Run `.download_fastq.sh` to download dataset into s3 bucket.
7. Update paths in nextflow.config, and you're good to go.
