#' @title Extract text from a single pdf document
#' 
#' @description This function wraps many methods to extract text from 
#' non-scanned PDFs - no OCR methods used here. Available methods include
#' xpdf, Ghostscript, and Poppler via \pkg{pdftools}
#' 
#' @export
#' @param paths (character) One or more paths to a file
#' @param which (character) One of gs, xpdf (default), or pdftools
#' @param ... further args passed on
#' @return A list or a single object, of class \code{gs_extr}, 
#' \code{xpdf_extr}, or \code{poppler_extr}. All share the 
#' same global class \code{extr}
#' 
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
#' # pdftools
#' pdft <- extract(path, "pdftools")
#' pdft$meta
#' cat(pdft$data)
#' 
#' # Pass many paths at once
#' path1 <- system.file("examples", "example1.pdf", package = "extractr")
#' path2 <- system.file("examples", "example2.pdf", package = "extractr")
#' path3 <- system.file("examples", "example3.pdf", package = "extractr")
#' extract(c(path1, path2, path3))
#' }
extract <- function(paths, which = "xpdf", ...){
  which <- match.arg(which, c("gs", "xpdf", "pdftools"))
  fxn <- switch(
    which,
    gs = extract_gs,
    xpdf = extract_xpdf,
    pdftools = extract_pdftools
  )
  if (length(paths) > 1) {
    lapply(paths, fxn, ...)
  } else {
    fxn(paths, ...)
  }
}

extract_pdftools <- function(path, which, ...){
  check4pdftools()
  path <- path.expand(path)
  res <- paste(pdftools::pdf_text(path), collapse = ", ")
  meta <- pdftools::pdf_info(path)
  structure(list(meta = meta, data = res), class = c("pdftools_extr", "extr"),
            path = path)
}

extract_gs <- function(path, which, ...){
  check_gs()
  path <- path.expand(path)
  res <- pdf_text_via_gs(path)
  res <- paste(res, collapse = ", ")
  meta <- pdf_info_via_gs(path)
  structure(list(meta = meta, data = res), class = c("gs_extr", "extr"),
            path = path)
}

extract_xpdf <- function(path, which, ...){
  check_pdftotext()
  cmds <- get_cmds(...)
  path <- path.expand(path)
  res <- system2("pdftotext", paste(cmds, shQuote(path)))
  newpath <- sub("\\.pdf", ".txt", path)
  res <- paste(readLines(newpath, warn = FALSE), collapse = ", ")
  meta <- pdf_info_via_xpdf(path)
  structure(list(meta = meta, data = res), class = c("xpdf_extr", "extr"),
            path = path)
}

get_cmds <- function(...){
  d <- list(...)
  if (length(d) == 0) "" else paste0(unlist(d), collapse = " ")
}

check_pdftotext <- function(x) {
  chk <- Sys.which("pdftotext")
  if (chk == "") stop("Please install xpdf. See ?extract_tools for more",
                      call. = FALSE)
}

check_gs <- function(x) {
  chk <- Sys.which("gs")
  if (chk == "") stop("Please install Ghostscript. See ?extract_tools for more",
                      call. = FALSE)
}

check4pdftools <- function() {
  if (!requireNamespace("pdftools", quietly = TRUE)) {
    stop("Please install pdftools", call. = FALSE)
  } else {
    invisible(TRUE)
  }
}

#' @export
print.gs_extr <- function(x, ...) {
  cat("<document>", attr(x, "path"), "\n", sep = "")
  cat("  Title: ", x$meta$Title, "\n", sep = "")
  cat("  Producer: ", x$meta$Producer, "\n", sep = "")
  cat("  Creation date: ", as.character(as.Date(x$meta$CreationDate)), "\n",
      sep = "")
}

#' @export
print.xpdf_extr <- function(x, ...) {
  cat("<document>", attr(x, "path"), "\n", sep = "")
  cat("  Pages: ", x$meta$Pages, "\n", sep = "")
  cat("  Title: ", x$meta$Title, "\n", sep = "")
  cat("  Producer: ", x$meta$Producer, "\n", sep = "")
  cat("  Creation date: ", as.character(as.Date(x$meta$CreationDate)), "\n",
      sep = "")
}
