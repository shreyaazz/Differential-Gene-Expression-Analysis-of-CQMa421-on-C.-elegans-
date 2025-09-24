# Differential Gene Expression Analysis of C. elegans Responding to CQMa421

---

## Project Overview
This project analyzes RNA-seq data of *C. elegans* exposed to **CQMa421** (*Metarhizium anisopliae*) to identify **differentially expressed genes (DEGs)** and their associated biological pathways. The workflow includes:
## Analysis Workflow

1. **Quality Control of Raw Reads**  
   - Checked sequencing quality using **FastQC** to assess read quality, adapter contamination, overrepresented sequences and other metrics.

2. **Transcript Alignment and Quantification**  
   - Aligned reads to the indexed reference genome (https://ftp.ensembl.org/pub/release-115/fasta/caenorhabditis_elegans/dna/Caenorhabditis_elegans.WBcel235.dna.toplevel.fa.gz) using **STAR**.  
   - Quantified transcript abundance using **RSEM** to generate counts matrices.

3. **Differential Expression Analysis**  
   - Performed differential gene expression with **Trinityrnaseq using DESeq2** for Control vs Treatment comparisons.

4. **Visualization**  
   - Generated **heatmaps**, **volcano plots**, **MA plots** and **PCA plots** to explore sample clustering and DEGs.

5. **Functional Enrichment Analysis**  
   - Conducted GO, KEGG, and Reactome enrichment using **gprofiler2** and **clusterProfiler**.


---

## RNA-Seq Sequence Data

Raw RNA-seq data were retrieved from the public domain:

- **BioProject:** [PRJNA1160025](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA11600250
- **SRA:** Control: SRR30641675, SRR30641676, SRR30641677
           Treatment: SRR30641672, SRR30641673, SRR30641674


## Study Design
- **Sample:** D1 stage *C. elegans* worms
| Group      | Treatment Details                        | Duration |
|------------|-----------------------------------------|----------|
| Control    | 1/4 SDAY liquid medium                   | 6 hours  |
| Treatment  | CQMa421 culture filtrate                 | 6 hours  |


**Citation:**  
Cheng, C., Zhang, R., Wang, Y., Yang, S., Yu, W., & Xia, Y. (2024). Transcriptome analysis of Metarhizium anisopliae CQMa421 in nematode treatment. NCBI BioProject PRJNA1160025 https://www.ncbi.nlm.nih.gov/bioproject/PRJNA1160025



