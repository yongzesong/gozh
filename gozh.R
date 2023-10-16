###############################################
# Geographical Optimal Zones-based Heterogeneity (GOZH) model
# 
# Yongze Song
# 16 October 2023
#
# To use the model/code in publications, please cite:
# Luo, P., Song, Y., Huang, X., Ma, H., Liu, J., Yao, Y., & Meng, L. (2022). Identifying determinants of spatio-temporal disparities in soil moisture of the Northern Hemisphere using a geographically optimal zones-based heterogeneity model. ISPRS Journal of Photogrammetry and Remote Sensing, 185, 111-128.
###############################################

library(GD)
data("ndvi_40")
library(rpart)
library(rpart.plot)

###############################################
# Calculate Omega values (power of determinants) of individual variables
###############################################

dt <- ndvi_40
vars <- names(dt)[-1]
gozh.omega <- data.frame(vars, "Omega" = NA, "sig" = NA)
for (i in 1:length(vars)){
  dti <- data.frame(dt[, 1, drop = FALSE], dt[, i+1, drop = FALSE])
  tree <- rpart(NDVIchange ~., data = dti) 
  dti$tree <- as.character(as.numeric(tree$where))
  g1 <- gd(NDVIchange ~ tree, dti)
  gozh.omega[i, 2] <- g1$Factor$qv
  gozh.omega[i, 3] <- g1$Factor$sig
}
gozh.omega

###############################################
# Calculate the Omega value (power of determinants) of all variables
###############################################

dtall <- ndvi_40
tree <- rpart(NDVIchange ~., data = dtall)
dtall$tree <- as.character(as.numeric(tree$where))
g1 <- gd(NDVIchange ~ tree, dtall)
g1
rpart.plot(tree, digits = 3, box.palette="GnYlRd") 

###############################################
# Note: 
# (1) The performance of GOZH can be compared with OPGD. 
# OPGD can be conducted using "GD" package: 
# https://cran.r-project.org/web/packages/GD/vignettes/GD.html
# (2) More parameters in rpart function can be found at:
# https://cran.r-project.org/web/packages/rpart/vignettes/longintro.pdf
###############################################

