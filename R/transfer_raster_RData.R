#' Transfer values from a Raster* object to an RData file
#'
#' Get the values of a Raster*, storage them into  an \code{\link[base]{array}} and
#' finally save the array in an RData  which allows for compatibility with multiple 
#' \code{R} functions as well as great portability.
#' 
#' @param inputFile  character with full path name of input file.
#' @param outputPath character with full path name (where the \code{RData} file will be saved). 
#'                   Do not include the extension .RData.
#' @param vmode      a character specifying the type of virtual storage mode \code{\link[ff]{vmode}} 
#'                   needed. Only \code{integer}, \code{single} and \code{double} are
#'                   allowed.
#' 
#' @export
#' 
#' @examples 
#' \donttest{
#' inputFile = system.file("extdata", "master.tif", package = "geoTS")
#' outputPath = paste0(system.file("extdata", package = "geoTS"), "/test")
#' transfer_raster_RData(inputFile = inputFile, outputPath = outputPath, 
#' vmode = "single")
#' }
#' 
#' @importFrom utils setTxtProgressBar
#' @importFrom utils txtProgressBar
#' @importFrom raster nrow
#' @importFrom raster ncol
#' @importFrom raster nlayers
#' @importFrom raster raster
#' @importFrom raster stack
#' @importFrom ff delete
#' 
#' @details Prior to embark the user in a transfer that may not be successful due to the
#' lack of RAM, this function provides an estimate of the amount of bytes to be used
#' in the transfer process. The estimate is obtained by multiplying the number of rows by the number of 
#' columns by the number of layers of the Raster* object to transfer by the amount of 
#' bites used by \code{vmode} (32-bit float for \code{integer} or \code{single} and 
#' 64-bit float for \code{double}). Should the user decide not to continue with the 
#' importation \code{transfer_raster_RData} returns the message \code{"Did not transfer anything"}.
#' 
#' @seealso \code{\link[ff]{vmode}}
#' 
#' @return At the designated path (\code{outputPath}) the user will find an \code{RData} file.
#' 
transfer_raster_RData <- function(inputFile, outputPath, vmode = c("integer", "single", "double")){
  
  if( missing(inputFile) | missing(outputPath) ){
    stop("inputFile and outputPath must be provided")
  }
  
  stack_TEMP <- stack(inputFile)
  
  roughBites <- ncol(stack_TEMP) * nrow(stack_TEMP) * nlayers(stack_TEMP)
    
  vmode <- match.arg(vmode)
  
  if(vmode == "single" | vmode == "integer"){
    bytes <- roughBites * 4 / (2^20)
  }
  
  if(vmode == "double"){
    bytes <- roughBites * 8 / (2^20)
  }
  
  message(paste0("Need ", round(bytes, 3), " MB (approx.) to complete the transfer"))
  answer <- readline(prompt = "Would you like to continue (y/n): ")
  
  if( answer == "y" | answer == "Y" ){

    index <- ff::ff( vmode = vmode, dim = c(nrow(stack_TEMP), ncol(stack_TEMP), nlayers(stack_TEMP)),
                     filename = paste0(outputPath, ".ffdata") )
    
    message(paste0("Started at: ", as.character(Sys.time()[1])))
    
    pBar <- txtProgressBar(min = 0, max = nlayers(stack_TEMP), style = 3)
    for(i in 1:nlayers(stack_TEMP)){
      Sys.sleep(0.1)
      index[, , i] <- stack_TEMP[[i]][]
      setTxtProgressBar(pBar, i)
    }
    close(pBar)
    
    temp <- 1:nlayers(stack_TEMP)
    
    index_array <- index[,,temp]  
    
    message("Please wait, your output file is being saved")
    
    save(index_array, file = paste0(outputPath, ".RData"))
    
    close(index)
    
    delete(index)
    
    message(paste0("Finished at: ", as.character(Sys.time()[1])))
    
  } else {
    message("Did not transfer anything")
  }
}