# Differential Gene Expression Analysis of C. elegans Responding to CQMa421

---

## Project Overview
This project analyzes RNA-seq data of *C. elegans* exposed to **CQMa421** (*Metarhizium anisopliae*) to identify **differentially expressed genes (DEGs)** and their associated biological pathways. The workflow includes:
## Analysis Workflow

1. **Quality Control of Raw Reads**  
   - Checked sequencing quality using **FastQC** to assess read quality, adapter contamination, overrepresented sequences and other metrics.

2. **Transcript Alignment and Quantification**  
   - Aligned reads to the indexed reference genome using **STAR**.  
   - Quantified transcript abundance using **RSEM** to generate counts matrices.

3. **Differential Expression Analysis**  
   - Performed differential gene expression with **Trinityrnaseq using DESeq2** for Control vs Treatment comparisons.

4. **Visualization**  
   - Generated **heatmaps**, **volcano plots**, **MA plots** and **PCA plots** to explore sample clustering and DEGs.

5. **Functional Enrichment Analysis**  
   - Conducted GO, KEGG, and Reactome enrichment using **gprofiler2** and **clusterProfiler**.

**Folder structure**
```
├── data/
│ ├── FastQC/ # FastQC HTML and summary result files
│ ├── RSEM_and_STAR/ # Gene and isoform count matrices (raw and normalized)
│ └── DE/ # Sample metadata for DE analysis
│
├── scripts/
│ ├── workflow_scripts/ # Bash scripts for DEG workflow
│ └── plot_scripts/ # R scripts for DESeq2 analysis, PCA, Heatmap, Enrichment
│
├── results/
│ ├── Trinityrnaseq_DESeq2/ # DESeq2 outputs: counts, significant genes, up/down-regulated lists
│ └── Visualizations/ # Summary tables and plots
│ ├── Enrichment/ # KEGG & GO dot plots, GO barplots
│ └── Plots/ # PCA, Volcano, MA plots, Heatmaps
│
└── README.md # Project overview, workflow, and interpretation
```

---

## RNA-Seq Sequence Data

Raw RNA-seq data were retrieved from the public domain:

- **BioProject:** [PRJNA1160025](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA11600250
- **SRA:** Control: SRR30641675, SRR30641676, SRR30641677. /n
           Treatment: SRR30641672, SRR30641673, SRR30641674

## Study Design
- **Sample:** D1 stage *C. elegans* worms
- **Layout:** Single
    
| Group     | Treatment Details            | Duration |
|-----------|------------------------------|----------|
| Control   | 1/4 SDAY liquid medium       | 6 hours  |
| Treatment | CQMa421 culture filtrate     | 6 hours  |

## Results 
## FastQC 
FastQC results showed high-quality sequencing reads with per base sequence quality having quality score above 30 and  absence of adapter content and overrepresented sequences. Thus, Trimmomatic is skipped

- Fastqc result of SRR30641672 sample
<img width="1838" height="908" alt="image" src="https://github.com/user-attachments/assets/7ec7dd2d-1c7e-461b-bc92-4cb9c81a5761" />

## RSEM and STAR 
Reads were aligned using STAR and counts were genereted via RSEM. Gene and isoform counts were produced per sample and then merged together one file.

- SRR30641672.genes.results obtained from STAR and RSEM
<img width="1842" height="668" alt="image" src="https://github.com/user-attachments/assets/a0e6b5a1-d78e-479b-95cc-282baf05a8e5" />


- Estimated abundances of every sample genes.results are formatted into matrix
<img width="1842" height="634" alt="image" src="https://github.com/user-attachments/assets/49ab48a9-8eec-4a3d-b7d5-f48b67af018e" />

## Differential Gene Expression
Differential Gene Expression Analysis was performed via Trinityrnaseq using DESeq2 method. Non-normalised isoform count matrix of control vs treatment, matix DE results, MA and Volcano plots were generated

-RSEM isoform counts matrix Control vs Treatment DESeq2 count_matrix
<img width="1842" height="668" alt="image" src="https://github.com/user-attachments/assets/9acc2199-c476-4597-a362-4bc77b4ac7dc" />


- RSEM isoform counts matrix Control vs Treatment DESeq2 DE_results.
  Determined the significant and non-significant genes with respect to padj values. Also determined upregulation and downregulation. 
  
<img width="1835" height="862" alt="image" src="https://github.com/user-attachments/assets/0c016f03-3b2a-42ce-9bac-aa73fbbaef5a" />


## Visualizations
### DEGs Plots
- **Volcano plot**
The volcano plot visually identifies differentially expressed genes (DEGs) by plotting the statistical significance against the magnitude of change. The plot shows a large number of red dots, which represent genes with a significant p-value (or False Discovery Rate, FDR) and a substantial fold change (logFC). The y-axis, labeled −1×log10​(FDR), highlights genes with very low p-values, such as WBGene00021978 and WBGene00017467, which are the most statistically significant. The x-axis, labeled logFC, shows the magnitude and direction of the change in expression. The plot reveals a greater number of genes with a negative logFC (down-regulated) compared to those with a positive logFC (up-regulated).

<img width="844" height="842" alt="Volcano" src="https://github.com/user-attachments/assets/2bc25522-c65a-42ff-a181-301a434eff38" />

- **MA plot**
The MA plot, or Mean-Average plot, is used to visualize the relationship between expression intensity and fold change. The plot's x-axis, logCounts, represents the average expression level (A), while the y-axis, logFC, represents the fold change (M). The plot shows a symmetrical distribution of red dots (significantly expressed genes) around the zero line on the y-axis for highly expressed genes. However, as the expression level decreases (lower logCounts), there is a prominent spread of red dots below the zero line, indicating a larger number of significant genes with a negative logFC. The distribution suggests that down-regulated genes tend to have lower average expression counts than up-regulated ones, a common observation in differential expression analysis.

<img width="848" height="848" alt="MA" src="https://github.com/user-attachments/assets/47c99905-7cfe-497f-b48a-56b0c750dc8b" />

- **Heatmap of Significant DEGs**
The heatmap provides a visualization of the expression patterns of all significant differentially expressed genes across all samples. The samples are hierarchically clustered and clearly separate into two distinct groups, corresponding to the treatment (light salmon) and control (olive green) conditions, confirming the results from the PCA plot. The genes also form distinct clusters based on their expression patterns. The top cluster of genes is highly expressed (indicated by darker shades of purple) in the treatment group and low in the control group (light shades of blue-green). Conversely, the bottom cluster shows the opposite pattern, with genes highly expressed in the control group and low in the treatment group. This heatmap provides a insightful visual summary, revealing the distinct transcriptional signatures induced by the treatment.

<img width="5600" height="4200" alt="heatmap_of_sig_deg" src="https://github.com/user-attachments/assets/d367e5bb-54e3-4f83-a047-925a28e33512" />

- **Principal Component Analysis plot (PCA)**
The PCA plot shows the clustering of samples based on their gene expression profiles. The plot indicates a clear separation between the control and treatment groups along the first principal component (PC1). This suggests that the treatment had a significant effect on the gene expression profile, accounting for 80% of the total variance in the data. The samples within each group cluster tightly, indicating good reproducibility within the replicates. The separation along PC1 demonstrates that the treatment is the primary driver of the observed variation. However, the one outlier in the treatment group (SRR30641672) is noteworthy, and its presence could be due to biological variation or an experimental anomaly.

<img width="5600" height="4200" alt="pca" src="https://github.com/user-attachments/assets/b85b25c7-2110-4c8b-abb1-4f2f5c132304" />

### Enrichment Plots
- **KEGG Pathway Analysis Dot Plot**
The KEGG dot plot reveals the most significantly enriched biological pathways. Each dot represents a pathway, with its size corresponding to the number of DEGs within that pathway (Count) and its color indicating the adjusted p-value (p.adjust), a measure of statistical significance. The pathways at the top, such as ABC transporters and Drug metabolism, have the largest dots and a dark red color, signifying that they are highly significant and contain a large number of DEGs. This suggests that the treatment significantly affects drug metabolism and transport processes within the organism. The Glycolysis and Fatty acid elongation pathways are also enriched, indicating changes in metabolic processes.

<img width="5600" height="4200" alt="geo_dot_plot" src="https://github.com/user-attachments/assets/ccc524f1-1d53-43d6-87d3-77e35595b888" />

- **GO Biological Process (BP) Dot Plot**
The GO BP dot plot highlights enriched biological processes from the Gene Ontology database. Similar to the KEGG plot, the dot size reflects the number of DEGs (Count), and the color represents the adjusted p-value. A prominent cluster of terms related to immune response and defense response are found at the top of the plot. These terms have a dark red color and large dot sizes, indicating they are very highly significant and involve a large number of DEGs. This suggests that the treatment elicits a strong immune or defense response in the organism. Other enriched terms include organic acid metabolic process and stress response to cadmium ion, pointing to other affected biological functions.

<img width="5600" height="4200" alt="geo_dot_plot" src="https://github.com/user-attachments/assets/103ea324-82ed-49aa-b993-c43b61db43a0" />

- **GO Biological Process (BP) Bar Plot**
The GO BP bar plot is another representation of the enriched GO terms, showing the top 10 enriched terms ranked by their statistical significance. The x-axis, −log10​(FDR), represents the significance, with longer bars indicating a higher significance. The plot visually confirms the findings from the dot plot, with terms such as response to other organism, defense response, and immune response having the longest bars, signifying their high statistical significance. This plot serves as a clear and concise summary of the primary biological functions and processes that are most affected by the treatment, reinforcing the conclusion that the organism is mounting a strong defensive and immune reaction.

<img width="5600" height="4200" alt="geo_bar_plot" src="https://github.com/user-attachments/assets/6caa0f17-7809-4637-b2d5-5d8c31687846" />

## Conclusion
The analysis reveals that the treatment induced a significant transcriptional response, which is primarily characterized by gene down-regulation. The clear separation of samples in the PCA and heatmap plots confirms a robust effect on gene expression. The Volcano and MA plots show that the majority of significant changes were down-regulatory. Finally, the functional enrichment analysis indicates that the genes with altered expression are involved in immune defense and metabolic processes, suggesting the organism perceives the treatment as a foreign substance and mounts a defense. Based on all the provided data and plots, the treatment has a significant and well-defined impact on the organism's transcriptome, primarily inducing a down-regulated gene expression profile.

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
13. https://github.com/twbattaglia/RNAseq-workflow
