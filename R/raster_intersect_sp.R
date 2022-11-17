#' Intersects raster and sp objects 
#' 
#' Straightforward application of \code{\link[raster]{crop}} and 
#' \code{\link[raster]{mask}} to extract the data in the intersection of
#' \code{Raster*} and \code{SpatialPolygonsDataframe} objects.
#' 
#' @param         x \code{Raster*} object
#' @param         y \code{SpatialPolygonsDataFrame} object
#' @param  features integer vector. Should some specifying features (polygons) of \code{y}
#'                  be intersected with \code{x}? When not provided, whole \code{y}
#'                  is intersected with \code{x}.  
#' @param      save logical. Should the output be saved? Default, \code{FALSE}.
#' @param dirToSave character specifying where to save output. Required when \code{save=TRUE}.
#' @param  baseName character. What should be the base name of output file? Default,  
#'                  \code{x_intersect_y}.
#' @param    format character specifying output file format. See \code{\link[raster]{writeFormats}}
#'                  for all supported formats. Default, \code{"GTiff"}.
#' 
#' @export
#' 
#' @examples 
#' \donttest{
#' raster_path = system.file("extdata", "MOD13Q1_NDVI_Mohinora.tif", package = "geoTS")
#' rasterSTACK <- stack(raster_path)
#' dir.create(path=paste0(system.file("extdata", package="geoTS"), "/output_raster_inter_sp"),
#'           showWarnings=FALSE)
#' dirToSave = paste0(system.file("extdata", package="geoTS"), "/output_raster_inter_sp")
#' 
#' raster_intersect_sp(x=rasterSTACK, y=shp_mohinora, save=TRUE, dirToSave=dirToSave, 
#'                     baseName="mohinora_NDVI_2001")
#' }
#' 
#' @importFrom raster crop 
#' @importFrom raster mask
#' @importFrom raster writeRaster
#' @importFrom raster dataType
#' @importFrom raster subset
#' 
#' @details When \code{save=TRUE}, \code{\link[raster]{writeRaster}} is used with
#' argument \code{datatype=dataType(subset(x,1))}. 
#' 
#' @return An object of class identical to that of argument \code{x}
#' 
raster_intersect_sp <- function(x, y, features, save=FALSE, dirToSave,
                                baseName="x_intersect_y", format="GTiff"){

  if( !(inherits(x, "RasterLayer") | inherits(x, "RasterStack") | inherits(x, "RasterBrick")) ){
    stop("x must be a Raster* object")    
  }
  
  if( !inherits(y, "SpatialPolygonsDataFrame") ){
    stop("y must be a SpatialPolygonsDataFrame")
  }
  
  x_y <- .raster_sp(x=x, y=y, features=features)
  
  if( save ){
    if( missing(dirToSave) ){
      stop("When save=TRUE, dirToSave must be provided")
    } else {
      writeRaster(x_y, 
                  filename = paste0(dirToSave, "/", baseName),
                  format=format,
                  datatype=dataType(subset(x,1)),
                  overwrite=TRUE)
    }
  } else {
    return(x_y)
  }
  
}


.raster_sp <- function(x,y,features){
  if(!missing(features)){
    temp <- crop(x, y[features,])
    temp <- mask(temp, y[features,])
  } else {
    temp <- crop(x, y)
    temp <- mask(temp, y)
  }
  
temp
}
