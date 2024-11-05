library(optparse)
cli <- function() {
  parser <- OptionParser()

  parser <- add_option(parser, "--counts", help="TSV file with gene counts")
  parser <- add_option(parser, "--scRef", help="RDA file with single cell reference counts")
  parser <- add_option(parser, "--output-prefix", default="", dest="output", help="Prefix for the output files")

  opt <- parse_args(parser)

  # Check for missing options
  if (is.null(opt$counts)) {
    stop("--counts is required")
  }
  if (is.null(opt$scRef)) {
    stop("--scRef is required")
  }

  opt
}

main <- function(options) {
  library(seAMLess)
  library(xbioc)
  source("R/seAMLess.R")

  verbose <- TRUE

  # Printing function
  verbosePrint <- verboseFn(verbose)
  verbosePrint(">> Reading ", options$counts, "...")
  counts <- read.table(options$counts)

  verbosePrint(">> Reading ",options$scRef, "...")
  load(file=options$scRef)

  res <- seAMLess(counts, scRef)

  verbosePrint(">> Writing output...")
  write.table(res$Deconvolution, paste(options$output, "celltypes.tsv", sep=""), sep="\t", quote=FALSE)
  write.table(res$Venetoclax.resistance, paste(options$output, "venetoclax.tsv", sep=""), sep="\t", quote=FALSE)
  verbosePrint(">> Done")
}

opt <- cli()
main(opt)
