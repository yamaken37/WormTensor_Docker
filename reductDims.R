# Package Loading
library("Rtsne")
library("irlba")
library("testthat")
library("uwot")

# Data Analysis Function
reductDims <- function(input, dim_pca=10, dim_tsne=2,dim_umap=2,
	type_pca=c("svd", "irlba"), verbose=TRUE){
	# Argument Check
	.checkreductDims(input, dim_pca, dim_tsne, verbose)
	type_pca <- match.arg(type_pca)
	# Initialization
	scaled_input <- .initreductDims(input)
	# PCA
	if(type_pca == "svd"){
		if(verbose){
			message("SVD (svd) is performing...")
		}
		out_PCA <- svd(scaled_input, nu=dim_pca, nv=dim_pca)
	}
	if(type_pca == "irlba"){
		if(verbose){
			message("SVD (irlba) is performing...")
		}
		out_PCA <- irlba(scaled_input, nu=dim_pca, nv=dim_pca)
	}
	# t-SNE
	if(verbose){
		message("t-SNE is performing...")
	}
	out_tsne <- Rtsne(out_PCA$u, dims=dim_tsne, perplexity=10)
	# UMAP
	if(verbose){
		message("UMAP is performing...")
	}
	out_umap <- uwot::umap(out_PCA$u, n_components=dim_umap, n_neighbors = 15, ret_nn=TRUE)
	# Output
	list(pca=out_PCA, tsne=out_tsne, umap=out_umap)
}

# Check Function
.checkreductDims <- function(input, dim_pca, dim_tsne, verbose){
	# 1. Check Input
	if(!is.matrix(input)){
		stop("Specify the input as a matrix object!")
	}
	# 2. Check dim_pca
	min_dim <- min(dim(input))
	if(dim_pca > min_dim){
		stop("Specify the dim_pca smaller than min(dim(input))!")
	}
	# 3. Check dim_tsne
	if(dim_tsne > min_dim){
		stop("Specify the dim_tsne smaller than min(dim(input))!")
	}
	# 5. Check verbose
	stopifnot(is.logical(verbose))
}

# Initialization Function
.initreductDims <- function(input){
	scale(input, center=TRUE, scale=FALSE)
}

# Misc
"%ni%" <- Negate("%in%")

# Visualization Function
plotDims <- function(out){
	layout(t(1:3))
	plot(out$pca$u[,1:2], main="PCA",
		xlab="Dim1", ylab="Dim2",
		col=rgb(0,0,1), pch=16)
	plot(out$tsne$Y, main="t-SNE",
		xlab="Dim1", ylab="Dim2",
		col=rgb(0,0,1), pch=16)
	plot(out$umap$embedding[,1:2], main="umap",
		xlab="Dim1", ylab="Dim2",
		col=rgb(0,0,1), pch=16)
}
