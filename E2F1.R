

# Extracting the UniProt IDs for all the E2F1 annotations when searched in UniProt
# Objective, is to be able to do MSA accross species Annotated with E2F1

### Data downloadable from the UniProt website with the search E2F1, these are all the downloadable results that come

E2F_query <- read_tsv("~/Downloads/uniprotkb_e2f1_2026_02_17.tsv")
View(E2F_query)

### Looking at the the data there are numerous genes that are not E2F1, so we will filter for E2F1 in Gene Names

library(tidyverse)

E2F1_filtered <- E2F_query %>%
  filter(grepl("E2F1", `Gene Names`, ignore.case = TRUE ))
E2F1_filtered

nrow(E2F1_filtered)
## Filtered down to 569 entries for genes named E2F1 on UniProt

# Now let's see how many distinct species entries are present:

n_distinct(E2F1_filtered$Organism)
## There are 483 species with entries here, indicating some of the species are repeating in entries, which is okay


# Let's look at the protein size distribution of E2F1 across the entries
library(ggplot2)
E2F1_size <- ggplot(E2F1_filtered, aes(x=Length, color="red")) + 
  scale_x_continuous(breaks = seq(0, max(E2F1_filtered$Length), by = 100)) +
  geom_density() + 
  theme_classic() + 
  labs( x = "Length (Amino Acids)", 
        title = "E2F1 Size Across Species (n = 483)",
        y = "Density") +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank(), legend.position = "none") 
 
E2F1_size

# It looks like there is a bimodal distribution with peaks around 350, 450 AA

# Now, let's extract the UniProt IDs, into a vector:

E2F1_annotation_vector <- pull(E2F1_filtered, Entry)
E2F1_annotation_vector

### Let's export this as a CSV:

cat(E2F1_annotation_vector, file = "~/Desktop/PhD/Projects/TF_RNA_Review/E2F1_uniprot_annotations_vector.csv", sep = ",")










