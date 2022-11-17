#' Heteroscedastic variance estimation for remotely-sensed data
#' 
#' Variance of some remotely-sensed Earth data is time-varying. Utilizing the 
#' observations per period (season, year), this function allows for estimation
#' of variability in data either as numeric vector or matricial form 
#' 
#' @param         x numeric vector
#' @param         m matrix with \code{nrow} equal to the number of periods (seasons 
#'                  or years) analyzed and \code{ncol} equal to the number of observations 
#'                  per period
#' @param lenPeriod numeric giving the number of observations per period.
#'                  Default, 23.
#' @param    method character specifying whether \code{standard} variance,
#'                  the median absolute deviation (\code{robust-mad}) or
#'                  the more efficient robust variance estimator (\code{robust-Qn}) 
#'                  should be used
#' 
#' @export
#' 
#' @importFrom stats sd
#' @importFrom stats mad
#' @importFrom robustbase Qn
#' 
#' @details Designed for data extracted from time series of satellite imagery. Then, it is expected that 
#' \code{length(x)} be a multiple of \code{lenPeriod}. When \code{m} is provided,
#' \code{ncol(m)} must be equal to \code{lenPeriod}. Default of \code{lenPeriod} corresponds to the 
#' temporal resolution of some MODIS products.
#' 
#' Method \code{standard} invokes \code{\link[stats]{sd}} whereas \code{robust-mad}
#' uses the median absolute deviation of \code{\link[stats]{mad}} and \code{robust-Qn}
#' utilizes the robust scale estimator implemented in \code{\link[robustbase]{Qn}}.
#' 
#' This function does not allow missing values.
#' 
#' @return A numeric vector of length \code{lenPeriod}
#' 
#' @seealso \code{\link[stats]{sd}}, \code{\link[stats]{mad}}, \code{\link[robustbase]{Qn}}
#' 
hetervar <- function(x, m=NULL, lenPeriod=23, method=c("standard", "robust-mad", "robust-Qn")){
  
  if( missing(x) & is.null(m) ){
    stop( "Either x or m must be provided" )
  }
  
  if( !missing(x) ){
    if( length(x) %% lenPeriod != 0 ){
      stop("length(x) must be a multiple of lenPeriod")
    } else {
      m <- get_pixel_matrix(x=x, lenPeriod=lenPeriod)
    }
  }
  
  if( !is.null(m) ){
    if( ncol(m) != lenPeriod ){
      stop("ncol(m) must be equal to lenPeriod")
    }
  }
  
  if( sum(is.na(m)) != 0){
    stop("This function does not allow NA")
  }
  
  method <- match.arg(method)
  
  if( method=="standard" ){
    output <- apply(X=m, MARGIN = 2, FUN = sd)
  }
  
  if( method=="robust-mad" ){
    output <- apply(X=m, MARGIN = 2, FUN = mad)
  }
  
  if( method=="robust-Qn" ){
    output <- apply(X=m, MARGIN = 2, FUN = Qn)
  }
  
output
}