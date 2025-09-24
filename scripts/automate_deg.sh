#!/bin/bash

# ================================
# Automated DEG Pipeline - Single-end
# ================================

BASE_DIR="$HOME/rnaseq"
RAW_DIR="$BASE_DIR/raw_reads"
TOOLS_DIR="$BASE_DIR/tools"
FASTQC_DIR="$BASE_DIR/FastQC"
RSEM_DIR="$TOOLS_DIR/RSEM-1.3.3"
STAR_DIR="$TOOLS_DIR/STAR-2.7.11b/source"
TRINITY_DIR="$TOOLS_DIR/trinityrnaseq"

SAMPLES=("SRR30641672" "SRR30641673" "SRR30641674" "SRR30641675" "SRR30641676" "SRR30641677")
CONTROL=("SRR30641675" "SRR30641676" "SRR30641677")
TREATMENT=("SRR30641672" "SRR30641673" "SRR30641674")

# ================================
# Step 0: Create folders
# ================================
echo "Creating folder structure..."
mkdir -p "$RAW_DIR" "$TOOLS_DIR" "$FASTQC_DIR" "$BASE_DIR/star" "$BASE_DIR/DE"

# ================================
# Step 1: Install and download SRA data
# ================================
echo "Installing SRA Toolkit and dependencies..."
sudo apt update
sudo apt install -y sra-toolkit wget unzip openjdk-11-jre

cd "$RAW_DIR" || exit
echo "Downloading SRA samples..."
for SRR in "${SAMPLES[@]}"; do
    fastq-dump --gzip "$SRR"
done

# ================================
# Step 2: Download and setup tools
# ================================
cd "$TOOLS_DIR" || exit

echo "Downloading FastQC..."
wget -q https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.1.zip
unzip -q fastqc_v0.12.1.zip
chmod +x FastQC/fastqc

echo "Downloading Trimmomatic..."
wget -q https://github.com/usadellab/Trimmomatic/releases/download/v0.40/Trimmomatic-0.40.zip
unzip -q Trimmomatic-0.40.zip

echo "Downloading STAR..."
wget -q https://github.com/alexdobin/STAR/releases/download/2.7.11b/STAR_2.7.11b.zip
unzip -q STAR_2.7.11b.zip

echo "Downloading RSEM..."
wget -q https://github.com/deweylab/RSEM/archive/refs/tags/v1.3.3.zip
unzip -q v1.3.3.zip
cd RSEM-1.3.3 || exit
make
cd "$TOOLS_DIR" || exit

echo "Downloading Trinity..."
git clone --recursive https://github.com/trinityrnaseq/trinityrnaseq.git

# ================================
# Step 3: Download reference genome
# ================================
cd "$BASE_DIR" || exit
echo "Downloading C. elegans reference genome..."
wget -q https://ftp.ensembl.org/pub/release-115/fasta/caenorhabditis_elegans/dna/Caenorhabditis_elegans.WBcel235.dna.toplevel.fa.gz
wget -q https://ftp.ensembl.org/pub/release-115/gtf/caenorhabditis_elegans/Caenorhabditis_elegans.WBcel235.115.gtf.gz

echo "Unzipping reference genome..."
gunzip -f Caenorhabditis_elegans.WBcel235.dna.toplevel.fa.gz
gunzip -f Caenorhabditis_elegans.WBcel235.115.gtf.gz

# ================================
# Step 4: Quality Control
# ================================
mkdir -p "$FASTQC_DIR/before"
echo "Running FastQC..."
for SRR in "${SAMPLES[@]}"; do
    "$TOOLS_DIR/FastQC/fastqc" "$RAW_DIR/${SRR}.fastq.gz" -o "$FASTQC_DIR/before"
done

# ================================
# Step 5: Prepare RSEM reference
# ================================
echo "Preparing RSEM reference..."
"$RSEM_DIR/rsem-prepare-reference" \
    --gtf "$BASE_DIR/Caenorhabditis_elegans.WBcel235.115.gtf" \
    --star --star-path "$STAR_DIR" \
    "$BASE_DIR/Caenorhabditis_elegans.WBcel235.dna.toplevel.fa" Reference_genome

# ================================
# Step 6: RSEM expression quantification
# ================================
echo "Running RSEM quantification..."
for SRR in "${SAMPLES[@]}"; do
    "$RSEM_DIR/rsem-calculate-expression" \
        --star --star-path "$STAR_DIR" \
        --star-gzipped-read-file \
        "$RAW_DIR/${SRR}.fastq.gz" \
        ../Reference_genome "$BASE_DIR/${SRR}"
done

# ================================
# Step 7: Differential Expression Analysis
# ================================
echo "Installing R and Bioconductor packages..."
sudo apt install -y r-base libcurl4-openssl-dev

Rscript -e 'if (!require("BiocManager", quietly=TRUE)) install.packages("BiocManager")'
Rscript -e 'BiocManager::install("edgeR")'
Rscript -e 'BiocManager::install("DESeq2")'

echo "Creating samples file..."
cat <<EOT > "$BASE_DIR/DE/samples_file"
Control	SRR30641675
Control	SRR30641676
Control	SRR30641677
Treatment	SRR30641672
Treatment	SRR30641673
Treatment	SRR30641674
EOT

echo "Generating count matrix..."
"$TRINITY_DIR/util/abundance_estimates_to_matrix.pl" \
    --est_method RSEM --gene_trans_map none "$BASE_DIR"/SRR3064167*.genes.results

echo "Running DESeq2 analysis..."
"$TRINITY_DIR/Analysis/DifferentialExpression/run_DE_analysis.pl" \
    --matrix "$BASE_DIR/RSEM.isoform.counts.matrix" \
    --method DESeq2 \
    --samples_file "$BASE_DIR/DE/samples_file"

echo "Pipeline completed successfully!"

