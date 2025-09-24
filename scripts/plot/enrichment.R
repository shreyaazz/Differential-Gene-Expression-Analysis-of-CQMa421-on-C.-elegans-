##########################################################
# Functional Enrichment Analysis in C. elegans
#   - gprofiler2 (GO/KEGG/Reactome)
#   - clusterProfiler + org.Ce.eg.db (GO + KEGG)
##########################################################

# ----------------------------
# Load libraries
# ----------------------------
library(gprofiler2)
library(ggplot2)

# ----------------------------
# g:Profiler Enrichment (GO + KEGG + Reactome)
# ----------------------------
# sig_genes contains significant DEGs (symbols or Ensembl IDs)
gene_list <- sig_genes

gostres <- gost(query = gene_list,
                organism = "celegans",
                significant = TRUE,
                correction_method = "fdr",
                sources = c("GO:BP", "GO:MF", "GO:CC", "KEGG", "REAC"))

# View top results
head(gostres$result[, c("term_name", "source", "p_value")])

# Plot Top 10 enriched terms
top_terms <- gostres$result[order(gostres$result$p_value), ][1:10, ]

ggplot(top_terms,
       aes(x = reorder(term_name, -log10(p_value)),
           y = -log10(p_value),
           fill = source)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  theme_minimal() +
  xlab("GO / Pathway Term") +
  ylab("-log10(FDR)") +
  ggtitle("Top 10 Enriched Terms in C. elegans DEGs")

#save
dev.copy(png,'geo_bar_plot.png', width=8, height=6, units="in", res=700)
dev.off()
##########################################################
# clusterProfiler + org.Ce.eg.db
##########################################################

# ----------------------------
# Install required packages (if not already installed)
# ----------------------------
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install(c("clusterProfiler", "org.Ce.eg.db"))

# ----------------------------
# Load libraries
# ----------------------------
library(clusterProfiler)
library(org.Ce.eg.db)

# ----------------------------
# Prepare gene list
# ----------------------------
# Assuming 'sig_genes' contains WormBase IDs
gene_ids <- bitr(sig_genes,
                 fromType = "WORMBASE",
                 toType   = "ENTREZID",
                 OrgDb    = org.Ce.eg.db)

gene_ids <- gene_ids$ENTREZID

# ----------------------------
# GO enrichment (Biological Process)
# ----------------------------
ego <- enrichGO(gene          = gene_ids,
                OrgDb         = org.Ce.eg.db,
                ont           = "BP",       # Biological Process
                pAdjustMethod = "BH",
                qvalueCutoff  = 0.05,
                readable      = TRUE)

# ----------------------------
# KEGG enrichment
# ----------------------------
# KEGG enrichment directly on Entrez IDs
ekegg <- enrichKEGG(gene         = gene_ids,      # already Entrez IDs
                    organism     = "cel",         # KEGG code for C. elegans
                    keyType      = "ncbi-geneid", # important!
                    pvalueCutoff = 0.05)

# ----------------------------
# Visualization
# ----------------------------
# Top GO terms
dotplot(ego, showCategory = 15) + ggtitle("Top GO:BP Terms")

#save 
dev.copy(png,'geo_dot_plot.png', width=8, height=6, units="in", res=700)
dev.off()


# Top KEGG pathways
dotplot(ekegg, showCategory = 15) + ggtitle("Top KEGG Pathways")

#save 
dev.copy(png,'kegg_dot_plot.png', width=8, height=6, units="in", res=700)
dev.off()
