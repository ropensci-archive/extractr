#' @title Extract text from a single pdf document
#' 
#' @description This function wraps many methods to extract text from 
#' non-scanned PDFs - no OCR methods used here. Available methods include
#' xpdf, Ghostscript, the Rcampdf package, and Poppler.
#' 
#' @export
#' @param paths (character) One or more paths to a file
#' @param which (character) One of rcamp, gs, xpdf (default), or poppler
#' @param ... further args passed on
#' @return A list or a single object, of class \code{rcamp_extr}, \code{gs_extr}, 
#' \code{xpdf_extr}, or \code{poppler_extr}. All share the same global class \code{extr}
#' @examples \dontrun{
#' path <- system.file("examples", "example1.pdf", package = "extractr")
#' 
#' # xpdf
#' xpdf <- extract(path, "xpdf")
#' xpdf$meta
#' xpdf$data
#' 
#' # Ghostscript
#' gs <- extract(path, "gs")
#' gs$meta
#' gs$data
#' 
#' # Rcampdf
#' rcamp <- extract(path, "rcamp")
#' rcamp$meta
#' rcamp$data
#' 
#' # Poppler
#' poppler <- extract(path, "poppler")
#' poppler$meta
#' poppler$data
#' 
#' # Pass many paths at once
#' path1 <- system.file("examples", "example1.pdf", package = "extractr")
#' path2 <- system.file("examples", "example2.pdf", package = "extractr")
#' path3 <- system.file("examples", "example3.pdf", package = "extractr")
#' extract(c(path1, path2, path3))
#' }
extract <- function(paths, which = "xpdf", ...){
  which <- match.arg(which, c("rcamp", "gs", "xpdf", "poppler"))
  fxn <- switch(which, 
         rcamp = extract_rcamp,
         gs = extract_gs,
         xpdf = extract_xpdf,
         poppler = extract_poppler
  )
  if (length(paths) > 1) {
    lapply(paths, fxn, ...)
  } else {
    fxn(paths, ...)
  }
}

extract_rcamp <- function(path, which, ...){
  check4rcamp()
  path <- path.expand(path)
  res <- paste(Rcampdf::pdf_text(path), collapse = ", ")
  meta <- Rcampdf::pdf_info(path)
  structure(list(meta = meta, data = res), class = c("rcamp_extr", "extr"), path = path)
}

extract_poppler <- function(path, which, ...){
  check4poppler()
  path <- path.expand(path)
  res <- paste(Rpoppler::PDF_text(path), collapse = ", ")
  meta <- Rpoppler::PDF_info(path)
  structure(list(meta = meta, data = res), class = c("poppler_extr", "extr"), path = path)
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

check4rcamp <- function() {
  if (!requireNamespace("Rcampdf", quietly = TRUE)) {
    stop("Please install Rcampdf", call. = FALSE)
  } else {
    invisible(TRUE)
  }
}

check4poppler <- function() {
  if (!requireNamespace("Rpoppler", quietly = TRUE)) {
    stop("Please install Rpoppler; See ?extractr_deps", call. = FALSE)
  } else {
    invisible(TRUE)
  }
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
