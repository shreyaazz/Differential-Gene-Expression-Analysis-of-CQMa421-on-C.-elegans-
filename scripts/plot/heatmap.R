library(DESeq2)
library(ComplexHeatmap)
library(circlize)

setwd("/home/rnaseq/DE")
# Load Trinity DESeq2 results (tab-delimited file)
res <- read.delim("DESeq2.1488092.dir/RSEM.isoform.counts.matrix.Control_vs_Treatment.DESeq2.DE_results", header = TRUE, row.names = 1)

# Load counts matrix (from Trinity)
counts <- read.delim("DESeq2.1488092.dir/RSEM.isoform.counts.matrix.Control_vs_Treatment.DESeq2.count_matrix", header = TRUE, row.names = 1)

# Make DESeq2 dataset (assuming first column is condition info in a separate sample file)
# You should have a sample info table: samples x condition
sample_info <- read.table("group.txt", header = TRUE)
dds <- DESeqDataSetFromMatrix(countData = counts,
                              colData = sample_info,
                              design = ~ Group)

# Variance stabilizing transform
vsd <- vst(dds, blind = FALSE)

# Pick significant genes from Trinity DESeq2 results
sig_genes <- rownames(res[res$padj < 0.05 & !is.na(res$padj), ])

# Subset VST matrix
mat <- assay(vsd)[sig_genes, ]

# Scale expression per gene (Z-score)
mat_scaled <- t(scale(t(mat)))

# Column annotation
ha <- HeatmapAnnotation(
  Condition = sample_info$Group,
  col = list(Condition = c("Control" = "olivedrab", "Treatment" = "lightsalmon"))
)

#plot the heatmap
Heatmap(mat_scaled,
        name = "Z-score",
        top_annotation = ha,
        show_row_names = FALSE,
        cluster_rows = TRUE,
        cluster_columns = TRUE,
        row_km = 2,  # <-- cuts rows into 2 clusters
        column_names_rot = 45,
        row_title = "Significant DEGs",
        col = colorRamp2(c(-2, 0, 2), c("darkcyan", "white", "mediumpurple4")))

#save the heatmap
dev.copy(png,'heatmap_of_sig_deg.png', width=8, height=6, units="in", res=700)
dev.off()
