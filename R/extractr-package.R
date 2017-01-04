#' @title R client for pdf extraction
#' 
#' @description R interface to many web and local pdf extraction tools.
#' 
#' @section Dependencies:
#' 
#' Most packages and tools are easy to install, but some require some more 
#' in depth instructions.
#' 
#' @section Tools used in extractr:
#' 
#' \itemize{
#'  \item XPDF - \url{http://www.foolabs.com/xpdf/} - Local usage
#'  \item Ghostscript - \url{http://www.ghostscript.com} - Local usage
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
