#' PDF-to-text conversion using XPDF
#' 
#' @param files (character) Path to a file, or files on your machine.
#' @param ... Further args passed on to the \code{tm} package, which does 
#' the conversion
#' 
#' @author Scott Chamberlain {myrmecocystus@@gmail.com}
#' @return A S3 object of class xpdf with slots for meta and data
#' 
#' @examples \dontrun{
#' path <- "~/github/sac/scott/pdfs/ChamberlainEtal2013Ecosphere.pdf"
#' res <- xpdf(files = path)
#' 
#' paths <- c("~/github/sac/scott/pdfs/BarraquandEtal2014peerj.pdf", 
#' "~/github/sac/scott/pdfs/Chamberlain&Holland2009Ecology.pdf",
#' "~/github/sac/scott/pdfs/Revell&Chamberlain2014MEE.pdf")
#' (res <- xpdf(files=paths))
#' res$data[[3]]
#' }

xpdf <- function(files = NULL, ...) {
  files_exist(files)
  files <- path.expand(files)
  out <- Corpus(
   URISource(files),
   readerControl = list(reader = readPDF(engine = "xpdf", control = list(...))))
  meta <- get_meta(out)
  structure(list(meta = meta, data = out), class = "xpdf")
}

#' Use pdftotext to get text from a pdf
#' 
#' @export
#' @param path A file path.
#' @param ... Further command line flags passed to pdftotext. see examples
#' @examples \donttest{
#' path <- "~/github/sac/scott/pdfs/ChamberlainEtal2013Ecosphere.pdf"
#' pdftotext(path)
#' }

pdftotext <- function(path, ...){
  cmds <- list(...)
  cmds <- if (length(cmds) == 0) "" else cmds
  path <- path.expand(path)
  system2(sprintf("pdftotext %s out.txt %s", path, cmds))
  txt <- readLines("out.txt")
  gsub("\f", "\n", txt)
}
