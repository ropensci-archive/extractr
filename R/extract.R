#' Extract text from a single pdf document
#' 
#' @export
#' @param path Path to a file
#' @param which One of rcamp, gs, or xpdf (default).
#' @param ... further args passed on
#' @return An object of class rcamp_extr, gs_extr, xpdf_extr, all share the 
#' same global class extr
#' @examples \donttest{
#' path <- system.file("examples", "example1.pdf", package = "extractr")
#' xpdf <- extract(path, "xpdf")
#' xpdf$meta
#' xpdf$data
#' gs <- extract(path, "gs")
#' gs$meta
#' gs$data
#' rcamp <- extract(path, "rcamp")
#' rcamp$meta
#' rcamp$data
#' }
extract <- function(path, which = "xpdf", ...){
  switch(which, 
         rcamp = extract_rcamp(path, ...),
         gs = extract_gs(path, ...),
         xpdf = extract_xpdf(path, ...)
  )
}

extract_rcamp <- function(path, which, ...){
  path <- path.expand(path)
  res <- paste(Rcampdf::pdf_text(path), collapse = ", ")
  meta <- Rcampdf::pdf_info(path)
  structure(list(meta = meta, data = res), class = c("rcamp_extr", "extr"), path = path)
}

extract_gs <- function(path, which, ...){
  check_gs()
  path <- path.expand(path)
  res <- pdf_text_via_gs(path)
  res <- paste(res, collapse = ", ")
  meta <- pdf_info_via_gs(path)
  structure(list(meta = meta, data = res), class = c("gs_extr", "extr"), path = path)
}

extract_xpdf <- function(path, which, ...){
  check_pdftotext()
  cmds <- get_cmds(...)
  path <- path.expand(path)
  res <- system2("pdftotext", paste(cmds, shQuote(path)))
  newpath <- sub("\\.pdf", ".txt", path)
  res <- paste(readLines(newpath, warn = FALSE), collapse = ", ")
  meta <- pdf_info_via_xpdf(path)
  structure(list(meta = meta, data = res), class = c("xpdf_extr", "extr"), path = path)
}

get_cmds <- function(...){
  d <- list(...)
  if (length(d) == 0) "" else paste0(unlist(d), collapse = " ")
}

check_pdftotext <- function(x) {
  chk <- Sys.which("pdftotext")
  if (chk == "") stop("Please install xpdf. See ?extract_tools for more", call. = FALSE)
}

check_gs <- function(x) {
  chk <- Sys.which("gs")
  if (chk == "") stop("Please install Ghostscript. See ?extract_tools for more", call. = FALSE)
}

#' @export
print.rcamp_extr <- function(x, ...) {
  cat("<document>", attr(x, "path"), "\n", sep = "")
  cat("  File size: ", x$meta$`File Size`, "\n", sep = "")
  cat("  Pages: ", x$meta$`File Size`, "\n", sep = "")
  cat("  Producer: ", x$meta$Producer, "\n", sep = "")
  cat("  Creation date: ", x$meta$`File Size`, "\n", sep = "")
}

#' @export
print.gs_extr <- function(x, ...) {
  cat("<document>", attr(x, "path"), "\n", sep = "")
  cat("  Title: ", x$meta$Title, "\n", sep = "")
  cat("  Producer: ", x$meta$Producer, "\n", sep = "")
  cat("  Creation date: ", as.character(as.Date(x$meta$CreationDate)), "\n", sep = "")
}

#' @export
print.xpdf_extr <- function(x, ...) {
  cat("<document>", attr(x, "path"), "\n", sep = "")
  cat("  Pages: ", x$meta$Pages, "\n", sep = "")
  cat("  Title: ", x$meta$Title, "\n", sep = "")
  cat("  Producer: ", x$meta$Producer, "\n", sep = "")
  cat("  Creation date: ", as.character(as.Date(x$meta$CreationDate)), "\n", sep = "")
}
