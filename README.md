extractr
=======



`extractr` is an R package with interfaces to various extraction services, from web APIs and from local software, including:

* [XPDF](http://www.foolabs.com/xpdf/)
* [Ghostscript](http://www.ghostscript.com/)
* [Rcampdf](http://datacube.wu.ac.at/)
* [pdfx](http://pdfx.cs.man.ac.uk/usage)
* [Poppler](http://poppler.freedesktop.org/)
* more to come ...

## Installation

For now, you'll need one pkg that's not on CRAN. May remove this dependency in the future. 


```r
install.packages("Rcampdf", repos = "http://datacube.wu.ac.at/", type = "source")
```

Install `extractr`


```r
install.packages("devtools")
devtools::install_github("sckott/extractr")
```

Load the package


```r
library("extractr")
```

## extract with local utilties

Get path to an example pdf, comes with the package


```r
path <- system.file("examples", "example1.pdf", package = "extractr")
```

### xpdf

xpdf is the default. The structure of the three method options (`xpdf`, `gs`, `rcamp`) for extracting using the `extract()` function give the same structure back: a simple list, a slot for metadata attached to the PDF, and a slot for data (the extracted text).


```r
xpdf <- extract(path, "xpdf")
xpdf$meta
#> $Title
#> [1] "Suffering and mental health among older people living in nursing homes---a mixed-methods study"
#> 
#> $Subject
#> [1] "doi:10.7717/peerj.1120"
#> 
#> $Keywords
#> [1] ""
#> 
#> $Author
#> [1] ""
#> 
#> $Creator
#> [1] "PeerJ"
#> 
...
```

Since the character string is very long, we'll just print a few hundred characters to give you a flavor of the text


```r
substr(xpdf$data, 1, 200)
#> [1] "Suffering and mental health among older, people living in nursing homes—a, mixed-methods study, Jorunn Drageset1,2 , Elin Dysvik3 , Birgitte Espehaug1 , Gerd Karin Natvig2, and Bodil Furnes3, 1 Facult"
```

### gs - Ghostscript


```r
gs <- extract(path, "gs")
gs$meta
#> $Title
#> [1] "\xfc\xbe\x99\x96\x98\xbc\xfc\xbe\x99\xa6\x98\xbc"
#> 
#> $Author
#> [1] ""
#> 
#> $Subject
#> [1] "\xfc\xbe\x99\x96\x98\xbc\xfc\xbe\x99\xa6\x98\xbc"
#> 
#> $Keywords
#> [1] ""
#> 
#> $Creator
#> [1] "\xfc\xbe\x99\x96\x98\xbc\xfc\xbe\x99\xa6\x98\xbc"
#> 
...
```


```r
substr(gs$data, 1, 200)
#> [1] "\n\nSubmitted 31 March 2015\nAccepted 2 July 2015\nPublished 30 July 2015\n\nCorresponding author\nJorunn Drageset,\nJorunn.Drageset@hib.no\n\nAcademic editor\nLia Fernandes\n\nAdditional Information and\nDeclarati"
```

### rcamp - Rcampdf


```r
rcamp <- extract(path, "rcamp")
rcamp$meta
#> $File
#> [1] "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/extractr/examples/example1.pdf"
#> 
#> $`File Size`
#> [1] "479939 bytes"
#> 
#> $Pages
#> [1] "18"
#> 
#> $Author
#> [1] ""
#> 
#> $CreationDate
#> [1] "2015-07-17 12:27:36 PDT"
#> 
...
```


```r
substr(rcamp$data, 1, 200)
#> [1] "Submitted 31March2015 Accepted 2July2015 Published 30July2015 Corresponding author, JorunnDrageset,, Jorunn.Drageset@hib.no, Academic editor, LiaFernandes, Additional Information and, Declarations can"
```

### poppler - Rpoppler


```r
poppler <- extract(path, "poppler")
poppler$meta
#> Title:        Suffering and mental health among older people living in nursing homes---a mixed-methods study
#> Subject:      doi:10.7717/peerj.1120
#> Keywords:     
#> Author:       
#> Creator:      PeerJ
#> Producer:     pdfTeX-1.40.10
#> CreationDate: 2015-07-17 20:57:36
#> ModDate:      2015-07-17 20:57:36
#> Pages:        18
#> Page size:    612 x 792 pts [letter]
...
```


```r
substr(poppler$data, 1, 200)
#> [1] "Suffering and mental health among older\npeople living in nursing homes—a\nmixed-methods study\nJorunn Drageset 1,2 , Elin Dysvik 3 , Birgitte Espehaug 1 , Gerd Karin Natvig 2\nand Bodil Furnes 3\n1 Facult"
```

## pdfx - A web API


```r
path <- system.file("examples", "example1.pdf", package = "extractr")
res <- pdfx(file = path)
```

The metadata


```r
res$meta
```

The extracted text


```r
res$data   
```


## Meta

> NOTE: Some of the code in this package has been adapted from the `tm` R package (`GPL-3` licensed), where we've borrowed some of their code for extracting text from PDFs, but have modified the code. 
