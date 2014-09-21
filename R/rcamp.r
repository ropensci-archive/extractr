#' PDF-to-text conversion using Rcampdf
#' 
#' Uses a local tool called Rcamppdf at \url{http://datacube.wu.ac.at/}.
#' 
#' @importFrom tm Corpus URISource readPDF
#' @importFrom plyr rbind.fill
#' @export
#' 
#' @param files (character) Path to a file, or files on your machine.
#' @param ... Further args passed on to the \code{tm} package, which does the conversion
#' 
#' @author Scott Chamberlain {myrmecocystus@@gmail.com}
#' @return A S3 object of class xpdf with slots for meta and data
#' 
#' @examples \dontrun{
#' path <- "~/github/sac/scott/pdfs/ChamberlainEtal2013Ecosphere.pdf"
#' rcampdf(files = path)
#' 
#' paths <- c("~/github/sac/scott/pdfs/BarraquandEtal2014peerj.pdf", 
#' "~/github/sac/scott/pdfs/Chamberlain&Holland2009Ecology.pdf",
#' "~/github/sac/scott/pdfs/Revell&Chamberlain2014MEE.pdf")
#' (res <- rcampdf(files=paths))
#' res$data[[3]]
#' }

rcampdf <- function(files = NULL, ...)
{
  files_exist(files)
  files <- path.expand(files)
  out <- Corpus(URISource(files), readerControl=list(reader=readPDF(engine="Rcampdf", control=list(...))))
  meta <- get_meta(out)
  structure(list(meta=meta, data=out), class="rcamp")
}
