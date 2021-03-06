################################################################################
# pca_from_features
################################################################################

#' PCA from features
#'
#' @description
#' Compute PCA from a dataframe of features.
#'
#' @param feats_folder String with the path to the folder of the features file.
#' @param otp Vector of observations to plot. \code{NULL} indicates all observations.
#' @param ftp Vector of features to plot.
#'
#' @return A list with class \code{princomp}.
#'
#' @export

pca_from_features <- function(feats_folder, ftp, otp=NULL) {
  # Load data from CSV files
  feats <- utils::read.table(
    file   = paste(feats_folder, "feats.csv", sep = ""),
    header = TRUE,
    sep    = ","
  )

  # otp conversion
  if (is.null(otp)) {
    otp <- 1:dim(feats)[1]
  }

  # PCA
  pca <- stats::prcomp(feats[otp, ftp], scale. = TRUE)
  return(pca)
}

################################################################################
# kmeans_from_features
################################################################################

#' k-means from features
#'
#' @description
#' Compute k-means from a dataframe of features.
#'
#' @param feats_folder String with the path to the folder of the features file.
#' @param ftp Vector of features to plot.
#' @param otp Vector of observations to plot. \code{NULL} indicates all observations.
#' @param centers Number of clusters.
#' @param iter_max Maximum number of iterations allowed.
#' @param nstart Number of random sets.
#'
#' @return Object of class \code{kmeans}.
#'
#' @export

kmeans_from_features <- function(feats_folder, ftp, otp=NULL, centers, iter_max=500, nstart=500) {
  # Fix random numbers
  set.seed(1981)
  
  # Load data from CSV files
  feats <- utils::read.table(
    file   = paste(feats_folder, "feats.csv", sep = ""),
    header = TRUE,
    sep    = ","
  )
  
  # otp conversion
  if (is.null(otp)) {
    otp <- 1:dim(feats)[1]
  }
  
  # Features 
  km_feats <- feats[otp, ftp]

  # Standard k-means method
  km_results <- list()
  for (cc in centers) {
    print(paste("Computing k-means for", cc, "clusters"))
    results <- stats::kmeans(
      x        = km_feats,
      centers  = cc,
      iter.max = iter_max,
      nstart   = nstart
    )
    km_results[[cc]] <- results
  }
  
  # Results
  km <- list(
    feats   = km_feats,
    results = km_results
  )
  
  return(km)
}

################################################################################
# pca_kmeans_analysis
################################################################################

#' PCA-k-means analysis
#'
#' @description
#' Compute PCA from a dataframe of features, select a reduced set of dimensions for the PCA scores (depending on the acummulated explained variance provided), then computes k-means.
#'
#' @param feats_folder String with the path to the folder of the features file.
#' @param otp Vector of observations to plot. \code{NULL} indicates all observations.
#' @param ftp Vector of features to plot.
#' @param min_var Minimum variance that the reduced set of principal components must fulfil (value between 0 and 1).
#' @param centers Number of clusters.
#'
#' @return Object of class \code{kmeans}.
#'
#' @export

pca_kmeans_analysis <- function(feats_folder, ftp, otp=NULL, min_var=0.95, centers) {
  # Fix random numbers
  set.seed(1981)
  # Compute PCA
  pca <- whyT2.1::pca_from_features(
    feats_folder = feats_folder, 
    ftp          = ftp,
    otp          = otp
  )
  # Get variance
  variance <- summary(pca)[["importance"]]
  # Number of principal components to select
  pc_number <- sum(variance[3,] < min_var) + 1
  print(paste("Selected", pc_number, "PCs, variance", variance[3,pc_number]))
  # Selection of the reduced set of PCA components
  reduced_pc_set <- pca$x[,1:pc_number]
  # Compute k-means
  results <- stats::kmeans(
    x         = reduced_pc_set,
    centers   = centers,
    algorithm = "MacQueen",
    iter.max  = 500,
    nstart    = 10000
  )
  # Results
  km <- list(
    feats   = reduced_pc_set,
    results = results
  )
  return(km)
}

################################################################################
# get_cluster_measures
################################################################################

get_cluster_measures <- function(data_df, cluster_vect) {
  # FUNCTION THAT COMPUTES SS (SQUARED SUM)
  ss <- function(x) sum(scale(x, scale = FALSE)^2)
  
  ### Compute tot.withinss
  withinss <- sapply(split(data_df, cluster_vect), ss)
  tot_withinss <- sum(withinss)
  
  ### Compute silhouette function
  sil <- cluster::silhouette(x = cluster_vect, dist = dist(data_df))
  # sil2 <- data.frame(cluster=sil[,1], sil_width=sil[,3])
  # sil_coeff <- max(sapply(split(sil2$sil_width, sil2$cluster), mean))
  mean_sil <- mean(sil[,3])
  
  ### Davies-Bouldin's Index
  db_index <- clusterSim::index.DB(x = data_df, cl = cluster_vect)

  ### Return
  o <- list(
    tot_withinss = tot_withinss,
    mean_sil     = mean_sil,
    db_index     = db_index$DB
  )
  return(o)
}