library(ggplot2)
library(ggrepel)
library(DESeq2)

# PCA data
pcaData <- plotPCA(vsd, intgroup = "Group", returnData = TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))

# Plot 
ggplot(pcaData, aes(x = PC1, y = PC2, color = Group)) +
  geom_point(size = 4) +
  stat_ellipse(level = 0.95, linetype = 2) +
  geom_text_repel(aes(label = name),
                  size = 3,
                  box.padding = 0.4,   # space around points
                  segment.color = "grey50") +
  xlab(paste0("PC1: ", percentVar[1], "% variance")) +
  ylab(paste0("PC2: ", percentVar[2], "% variance")) +
  scale_color_manual(values = c("Control" = "olivedrab", "Treatment" = "lightsalmon")) +
  theme_minimal(base_size = 14) +
  ggtitle("PCA of CQMa421 Treatment v/s Control Samples")

#save the PCA plot
dev.copy(png,'pca.png', width=8, height=6, units="in", res=700)
dev.off()

