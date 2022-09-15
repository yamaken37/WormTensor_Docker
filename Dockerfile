# Base Image
FROM --platform=linux/amd64 bioconductor/bioconductor_docker:RELEASE_3_15

# Install R Packages
RUN R -e 'BiocManager::install(c("rTensor","usedist","dtwclust","clusterSim","clValid","aricode","cluster","ggplot2","Rtsne","uwot","factoextra","ggrepel","cowplot","methods","devtools","WormTensor"), update = FALSE, force = TRUE)'
