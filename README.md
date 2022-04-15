seAMLess
================

## Overview

`seAMLess` is a wrapper function which deconvolutes bulk Acute Myeloid
Leukemia (AML) RNA-seq samples with a healthy single cell reference
atlas.

![<https://eonurk.github.io/cinaR/articles/cinaR.html>](man/figures/Figure1-A.png)

## Installation

To get bug fix and use a feature from the development version:

``` r
# install.packages("devtools")
devtools::install_github("eonurk/seAMLess")
```

## Usage

``` r
library(seAMLess)

data(exampleTCGA)
res <- seAMLess(exampleTCGA)
```

    ## >> Human ensembl ids are converted to symbols...

    ## >> Deconvoluting samples...

    ## >> Deconvolution completed...

    ## >> Predicting Venetoclax resistance...

    ## >> Done...

``` r
# AML deconvolution
head(res$Deconvolution)[,1:5]
```

    ##                  CD14 Mono       GMP     T Cells      pre B       LMPP
    ## TCGA.AB.2856.03A 0.1495886 0.7079107 0.022868623 0.00000000 0.00000000
    ## TCGA.AB.2849.03A 0.0000000 0.0000000 0.000000000 0.00000000 0.01544562
    ## TCGA.AB.2971.03A 0.5494418 0.4462562 0.002898678 0.00000000 0.00000000
    ## TCGA.AB.2930.03A 0.0000000 0.4698555 0.000000000 0.00000000 0.18026732
    ## TCGA.AB.2891.03A 0.0000000 0.6189622 0.018645484 0.01384012 0.00000000
    ## TCGA.AB.2872.03A 0.0000000 0.9950150 0.000000000 0.00000000 0.00000000

``` r
# Venetoclax resistance
res$Venetoclax.resistance[1:5]
```

    ## TCGA.AB.2856.03A TCGA.AB.2849.03A TCGA.AB.2971.03A TCGA.AB.2930.03A 
    ##        0.5070113        0.3242576        0.6678995        0.3305996 
    ## TCGA.AB.2891.03A 
    ##        0.3472052

## Contribution

You can send pull requests to make your contributions.

## Author

-   [E Onur Karakaslar](https://eonurk.github.io/)

## License

-   GNU General Public License v3.0
