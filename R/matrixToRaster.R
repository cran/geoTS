#' Creates a RasterLayer object from a matrix
#'
#' Transforms a \code{matrix} into a \code{RasterLayer} object. 
#' 
#' @param matrix a matrix object.
#' @param RASTER a RasterLayer object whose extent and projection will be used to
#'               create a raster from \code{matrix}. 
#'               
#' @export
#' 
#' @importFrom raster raster
#' @importFrom raster rasterToPoints
#' @importFrom raster projection
#' 
#' @details The \code{\link[sp]{coordinates}} and \code{\link[raster]{projection}} of 
#' the argument \code{RASTER} are used to create a raster from the argument \code{matrix}.
#' 
#' @return A RasterLayer 
#' 
matrixToRaster <- function(matrix, RASTER){
  rasterTable <- data.frame(rasterToPoints(RASTER))
  
  df <- data.frame(x = rasterTable$x, y = rasterTable$y, values = c(matrix))
  
  sp::coordinates(df) <- ~ x + y
  
  sp::gridded(df) <- TRUE
  
  raster_df <- raster(df)
  
  raster::projection(raster_df) <- raster::projection(RASTER)
  
  raster_df
}
