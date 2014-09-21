extract
=======

`extract` is an R package with interfaces to various extraction services, from web APIs and from local software, including:

* [pdfx](http://pdfx.cs.man.ac.uk/usage)
* ...

## Quick start

Install


```r
install.packages("devtools")
devtools::install_github("sckott/extract")
```

Load the package


```r
library("extract")
```

### pdfx


```r
path <- "~/github/sac/hovick_work/pdfs/Vaughn1937_Mauritius.pdf"
(res <- pdfx(file = path))
```


```r
$meta
$meta$job
[1] "14891d13cb93fa778d9e73b9f5dc7dfd5bc7aa10669067ea163147ced31a3cba"

$meta$base_name
[1] "5fwa"

$meta$doi
[1] "http://dx.doi.org/10.1111/j.1095-8339.1937.tb01908.x"

$meta$warning
[1] "Original PDF was found to be an image-based/possible OCR document. Output quality may be degraded."


$data
<?xml version="1.0" encoding="UTF-8"?>
<pdfx xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://pdfx.cs.man.ac.uk/static/article-schema.xsd">
  <meta>
    <job>14891d13cb93fa778d9e73b9f5dc7dfd5bc7aa10669067ea163147ced31a3cba</job>
    <base_name>5fwa</base_name>
    <doi>http://dx.doi.org/10.1111/j.1095-8339.1937.tb01908.x</doi>
    <warning>Original PDF was found to be an image-based/possible OCR document. Output quality may be degraded.</warning>
  </meta>
  <article>
    <front class="DoCO:FrontMatter">
      <outsider class="DoCO:TextBox" type="header" id="1">CONTRIBUTIONS TO THE FLORA OF MAURITIUS</outsider>
      <outsider class="DoCO:TextBox" type="page_nr" id="2">285</outsider>
      <title-group>
        <article-title class="DoCO:Title" id="4">Contributions to the flora of Mauritius.-!. An account of the naturalized flowering plants recorded from Mauritius since the publication of Baker's 'Flora of Mauritius and the Seychelles' (1877). By R. E. VAUGHAN, Ph.D., F.L.S.</article-title>
      </title-group>
    </front>
    <body class="DoCO:BodyMatter">

... cutoff
```