#' @title R client for pdf extraction
#' 
#' @description R interface to many web and local pdf extraction tools.
#' 
#' @section Dependencies:
#' 
#' See \code{\link{extractr_deps}} for information on dependencies. Most 
#' packages and tools are easy, but some require some more in depth 
#' instructions.
#' 
#' @section Tools used in extractr:
#' 
#' \itemize{
#'  \item XPDF - \url{http://www.foolabs.com/xpdf/} - Local usage
#'  \item Ghostscript - \url{http://www.ghostscript.com} - Local usage
#'  \item Rcampdf - \url{http://datacube.wu.ac.at/} - Local usage
#'  \item pdftools - Package \pkg{pdftools} that uses the Poppler library 
#'  \url{http://poppler.freedesktop.org/} - Local usage
#'  \item pdfx - \url{http://pdfx.cs.man.ac.uk/usage} - Web API
#' }
#' 
#' @importFrom httr GET POST content_type upload_file content write_disk
#' @import XML
#' @name extractr-package
#' @aliases extractr
#' @docType package
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @keywords package
NULL

#' @title extractr dependencies
#' 
#' @description You can optionally use \code{Rcampdf} and \code{Rpoppler} in 
#' this package.  These two packages are not available easily via 
#' \code{\link{install.packages}}, so we put them in \code{Suggests} in this 
#' package, so are only required if they are chosen as an option in 
#' function calls.
#' 
#' @section Rcampdf:
#' You can get get \code{Rcampdf} by doing 
#' \code{install.packages("Rcampdf", repos = "http://datacube.wu.ac.at/", 
#' type = "source")}
#' 
#' @name extractr_deps
NULL
