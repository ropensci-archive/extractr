#' PDF-to-XML conversion of scientific articles using pdfx
#' 
#' Uses a web service provided by Utopia at \url{http://pdfx.cs.man.ac.uk/}.
#' 
#' @import httr XML
#' @export
#' 
#' @param file (character) Path to a file, or files on your machine.
#' @param what (character) One of parsed, text, or html. 
#' @param ... Further args passed to \code{\link[httr]{GET}}. These aren't named, so just do e.g. ,
#' \code{verbose()}, or \code{timeout(3)}
#' 
#' @author Scott Chamberlain {myrmecocystus@@gmail.com}
#' @return Raw XML text, parsed to XMLInternalDocument, or to html text
#' 
#' @examples \dontrun{
#' path <- "~/github/sac/hovick_work/pdfs/Vaughn1937_Mauritius.pdf"
#' pdfx(file = path)
#' }

pdfx <- function(file = NULL, what = "parsed", ...)
{
  out <- pdfx_POST(file, ...)
  parsed <- xmlParse(out)
  meta <- pdfx_get_meta(parsed)
  
  toput <- switch(what, 
         parsed = XML::xmlParse(tt),
         text = tt,
         html = "not yet"
  )
  structure(list(meta=meta, data=toput), class="pdfx")
}

pdfx_POST <- function(file, ...) {
  url <- "http://pdfx.cs.man.ac.uk"
  res <- POST(url, config=c(content_type("application/pdf"), ...), body = upload_file(file))
  if(!res$status_code == 200) stop("something's wrong", call.=FALSE)
  stopifnot(res$headers$`content-type` == "text/xml")
  content(res, as = "text")
}

pdfx_get_meta <- function(x){
  xpathApply(x, "//meta", xmlToList)[[1]]
}

# pdfx_job_details <- function(...){
#   
# }
