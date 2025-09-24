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
     
├── data/           
│   ├── FastQC/             # FastQC HTML and summary result files
│   ├── RSEM_and_STAR/      # Gene and isoform count matrices (raw and normalized)
│   └── DE/                 # sample metadata for DE analysis

├── scripts/                # Bash and R scripts for DESeq2, PCA, Heatmap, and enrichment plots
│ 
├── results/        
│   ├── Trinityrnaseq-DESeq2/  # DESeq2 output: count matrices, significant/non-significant genes, up/down-regulated genes
│   ├── Visualizations/         # Summary tables and plots
│   │   ├── Enrichment/         # KEGG and GO dot plots, GO barplots
│   │   └── Plots/              # PCA, Volcano, MA plots, Heatmaps
│
└── README.md                 # Project overview, workflow, and interpretation

---

## RNA-Seq Sequence Data

Raw RNA-seq data were retrieved from the public domain:

- **BioProject:** [PRJNA1160025](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA11600250
- **SRA:** Control: SRR30641675, SRR30641676, SRR30641677
           Treatment: SRR30641672, SRR30641673, SRR30641674


## Study Design
- **Sample:** D1 stage *C. elegans* worms
| Group     | Treatment Details            | Duration |
|-----------|------------------------------|----------|
| Control   | 1/4 SDAY liquid medium       | 6 hours  |
| Treatment | CQMa421 culture filtrate     | 6 hours  |

## Results 
## FastQC 
FastQC results showed high-quality sequencing reads with per base sequence quality having quality score above 30 and  absence of adapter content and overrepresented sequences. Thus, Trimmomatic is skipped

<img width="1838" height="908" alt="image" src="https://github.com/user-attachments/assets/7ec7dd2d-1c7e-461b-bc92-4cb9c81a5761" />

## RSEM and STAR 
Reads were aligned using STAR and counts were genereted via RSEM. Gene and isoform counts were produced per sample and then merged together one file.
<img width="1842" height="634" alt="image" src="https://github.com/user-attachments/assets/49ab48a9-8eec-4a3d-b7d5-f48b67af018e" />

## Differential Gene Expression
Differential Gene Expression Analysis was performed via Trinityrnaseq using DESeq2 method. Non-normalised isoform count matrix of control vs treatment, matix DE results, MA and Volcano plots were generated



**Citations and References:**  
1. Cheng, C., Zhang, R., Wang, Y., Yang, S., Yu, W., & Xia, Y. (2024). Transcriptome analysis of Metarhizium anisopliae CQMa421 in nematode treatment. NCBI BioProject PRJNA1160025 https://www.ncbi.nlm.nih.gov/bioproject/PRJNA1160025
2. Andrews S. (2010). FastQC: a quality control tool for high throughput sequence data. Available online at: http://www.bioinformatics.babraham.ac.uk/projects/fastqc
3. Dobin A, Davis CA, Schlesinger F, et al. STAR: ultrafast universal RNA-seq aligner. Bioinformatics. 2013;29(1):15-21. doi:10.1093/bioinformatics/bts635.
4. Li, B., Dewey, C.N. RSEM: accurate transcript quantification from RNA-Seq data with or without a reference genome. BMC Bioinformatics 12, 323 (2011). https://doi.org/10.1186/1471-2105-12-323
5. Grabherr MG, Haas BJ, Yassour M, Levin JZ, Thompson DA, Amit I, Adiconis X, Fan L, Raychowdhury R, Zeng Q, Chen Z, Mauceli E, Hacohen N, Gnirke A, Rhind N, di Palma F, Birren BW, Nusbaum C, Lindblad-Toh K, Friedman N, Regev A. Full-length transcriptome assembly from RNA-seq data without a reference genome. Nat Biotechnol. 2011 May 15;29(7):644-52. doi: 10.1038/nbt.1883. PubMed PMID: 21572440.
6. Love, M.I., Huber, W. & Anders, S. Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. Genome Biol 15, 550 (2014). https://doi.org/10.1186/s13059-014-0550-8
7. Gu, Z. (2022). Complex heatmap visualization. iMeta, 1(3). https://doi.org/10.1002/imt2.43
8. Zuguang Gu, Lei Gu, Roland Eils, Matthias Schlesner, Benedikt Brors, circlize implements and enhances circular visualization in R , Bioinformatics, Volume 30, Issue 19, October 2014, Pages 2811–2812, https://doi.org/10.1093/bioinformatics/btu393
9. Kolberg L, Raudvere U, Kuzmin I, Vilo J, Peterson H (2020). “gprofiler2– an R package for gene list functional enrichment analysis and namespace conversion toolset g:Profiler.” F1000Research, 9 (ELIXIR)(709). R package version 0.2.3. 
10. Yu G, Wang L, Han Y and He Q (2012). “clusterProfiler: an R package for comparing biological themes among gene clusters.” OMICS: A Journal of Integrative Biology, 16(5), pp. 284-287.
11. Wickham H (2016). ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York. ISBN 978-3-319-24277-4, https://ggplot2.tidyverse.org.
12. Slowikowski K (2024). ggrepel: Automatically Position Non-Overlapping Text Labels with 'ggplot2'. https://ggrepel.slowkow.com/, https://github.com/slowkow/ggrepel. 

