#' MOD13Q1 NDVI binary file
#' 
#' Spatial subset of a MOD13Q1 NDVI layer, in binary format, covering eastern 
#' Yucatan Peninsula, Mexico. \href{https://en.wikipedia.org/wiki/Normalized_difference_vegetation_index}{NDVI} stands for Normalized Difference
#' Vegetation Index; NDVI = (NIR-RED)/(NIR+RED) where NIR and RED are the Near
#' Infrared and Red bands of the MODIS product, respectively. More information
#' about the MODIS mission can be found \href{https://modis.gsfc.nasa.gov/about/}{here}.
#' 
#' @name MOD13Q1_NDVI_2000129_009
#' 
#' @section MOD13Q1_NDVI_2000129_009.bin:
#' 
#' This image contains NDVI measurements for the 129-th Julian day of 2000; the
#' subscript \emph{_009} signifies that this was the 9th NDVI observation of 2000.
NULL

#' 16-day MOD13Q1 NDVI RasterStack
#'
#' A \code{RasterStack} containing 23 layers of NDVI for 2001. This \code{RasterStack} 
#' is a spatial subset covering the Protected Area of Flora and Fauna \bold{Cerro Mohinora} 
#' at Chihuahua, Mexico. 
#' 
#' @name MOD13Q1_NDVI_Mohinora
#' 
#' @section MOD13Q1_NDVI_Mohinora.tif:
#' 
#' A \code{RasterStack} object with 59 rows, 93 columns, 5487 cells and 23 layers.
NULL

#' Land Mask of eastern Yucatan Peninsula
#' 
#' A \code{RasterLayer} with a spatial subset covering eastern Yucatan Peninsula
#' of Mexico. A land mask is a binary layer where \code{1=Land}, \code{0=Water}.
#' 
#' @name master
#'
#' @section master.tif:
#' 
#' A \code{RasterLayer} object with 500 rows, 600 columns. Each cell has a resolution
#' of 250m.
NULL

