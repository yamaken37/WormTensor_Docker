# Base Image
FROM bioconductor/bioconductor_docker:RELEASE_3_14

# Download from GitHub
ADD reductDims.R /
ADD cmd_reductDims.R /

# Install R Packages
# RUN R -e 'install.packages(c("Rtsne", "irlba", "testthat", "uwot"), repos="http://cran.r-project.org")'
RUN R -e 'BiocManager::install(c("Rtsne", "irlba", "testthat", "uwot"), update = FALSE, force = TRUE)'