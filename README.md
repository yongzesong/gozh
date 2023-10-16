# R Codes for the Geographical Optimal Zones-based Heterogeneity (GOZH) model

**Author**: Yongze Song  
**Date**: 16 October 2023

**Reference**:  
Luo, P., Song, Y., Huang, X., Ma, H., Liu, J., Yao, Y., & Meng, L. (2022). Identifying determinants of spatio-temporal disparities in soil moisture of the Northern Hemisphere using a geographically optimal zones-based heterogeneity model. ISPRS Journal of Photogrammetry and Remote Sensing, 185, 111-128. doi: [10.1016/j.isprsjprs.2022.01.009](https://doi.org/10.1016/j.isprsjprs.2022.01.009).

Click [here](https://github.com/yongzesong/gozh/blob/main/gozh.R) to download the R codes below.

---

## Setup and Data Loading

```R
library(GD)
data("ndvi_40")
library(rpart)
library(rpart.plot)
```

## Calculate Omega values (power of determinants) of individual variables

```R
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
````

## Calculate the Omega value (power of determinants) of all variables
```R
dtall <- ndvi_40
tree <- rpart(NDVIchange ~., data = dtall)
dtall$tree <- as.character(as.numeric(tree$where))
g1 <- gd(NDVIchange ~ tree, dtall)
g1
rpart.plot(tree, digits = 3, box.palette="GnYlRd") 
```

## Notes

1. The performance of GOZH can be compared with OPGD. OPGD can be conducted using "GD" package: [Optimal Parameters-based Geographical Detectors (OPGD) Model for Spatial Heterogeneity Analysis and Factor Exploration](https://cran.r-project.org/web/packages/GD/vignettes/GD.html)

2. More parameters in rpart function can be found at: [rpart documentation](https://cran.r-project.org/web/packages/rpart/vignettes/longintro.pdf)



