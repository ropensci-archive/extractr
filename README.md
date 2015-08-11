extractr
=======



`extractr` is an R package with interfaces to various extraction services, from web APIs and from local software, including:

* [XPDF](http://www.foolabs.com/xpdf/)
* [Ghostscript](http://www.ghostscript.com/)
* [Rcampdf](http://datacube.wu.ac.at/)
* [pdfx](http://pdfx.cs.man.ac.uk/usage)
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
#> [1] "Suffering and mental health among older people living in nursing homes--a mixed-methods study, Jorunn Drageset1,2, Elin Dysvik3, Birgitte Espehaug1, Gerd Karin Natvig2 and Bodil Furnes3, 1 Faculty of "
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

## pdfx - A web API


```r
path <- system.file("examples", "example1.pdf", package = "extractr")
res <- pdfx(file = path)
```

The metadata


```r
res$meta
#> $job
#> [1] "dc56364e1d52f1fe6a83afbd39a4a9001f71fd16856813cc4c33bf75da539522"
#> 
#> $base_name
#> [1] "ad4"
#> 
#> $doi
#> [1] "10.7717/peerj.1120"
#> 
#> $warning
...
```

The extracted text


```r
res$data   
#> <?xml version="1.0" encoding="UTF-8"?>
#> <pdfx xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://pdfx.cs.man.ac.uk/static/article-schema.xsd">
#>   <meta>
#>     <job>dc56364e1d52f1fe6a83afbd39a4a9001f71fd16856813cc4c33bf75da539522</job>
#>     <base_name>ad4</base_name>
#>     <doi>10.7717/peerj.1120</doi>
#>     <warning>Name identification was not possible. </warning>
#>   </meta>
#>   <article>
#>     <front class="DoCO:FrontMatter">
#>       <title-group>
#>         <article-title class="DoCO:Title" id="1">Suffering and mental health among older people living in nursing homesâa mixed-methods study</article-title>
#>       </title-group>
#>       <outsider class="DoCO:TextBox" type="sidenote" id="2">1 2 3</outsider>
#>       <region class="unknown" id="3">Jorunn Drageset 1,2 , Elin Dysvik 3 , Birgitte Espehaug 1 , Gerd Karin Natvig 2 and Bodil Furnes 3 Faculty of Health and Social Sciences, Bergen University College, Norway Department of Global Public Health and Primary Care, University of Bergen, Norway Department of Health Studies, Faculty of Social Sciences, University of Stavanger, Norway</region>
...
```


## Meta

> NOTE: Some of the code in this package has been adapted from the `tm` R package (`GPL-3` licensed), where we've borrowed some of their code for extracting text from PDFs, but have modified the code. 
