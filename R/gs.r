#' PDF-to-text conversion using Ghostscript
#' 
#' Uses a local tool called xpdf at \url{http://www.ghostscript.com/}.
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
#' gs(files = path)
#' 
#' paths <- c("~/github/sac/scott/pdfs/BarraquandEtal2014peerj.pdf", 
#' "~/github/sac/scott/pdfs/Chamberlain&Holland2009Ecology.pdf",
#' "~/github/sac/scott/pdfs/Revell&Chamberlain2014MEE.pdf")
#' res <- gs(files=paths)
#' }

gs <- function(files = NULL, ...)
{
  files_exist(files)
  files <- path.expand(files)
  out <- Corpus(URISource(files), readerControl=list(reader=readPDF(engine="ghostscript", control=list(...))))
  meta <- get_meta(out)
  structure(list(meta=meta, data=out), class="xpdf")
}

files_exist <- function(x){
  tmp <- sapply(x, file.exists)
  if(!all(tmp)) stop(sprintf("These do not exist or can not be found:\n%s", 
                             paste(names(tmp[tmp == FALSE]), collapse="\n") ))
}

get_meta <- function(input){
  do.call(rbind.fill, lapply(input, function(x) {
    tmp <- attributes(x)
    tmp[sapply(tmp, length)==0] <- NA
    tmp <- lapply(tmp, function(z) if(length(z) > 1) paste(z, collapse = ", ") else z)
    data.frame(tmp, stringsAsFactors = FALSE)
  }))
}

# tm:::pdf_text_via_gs(path.expand(paths[1]))
