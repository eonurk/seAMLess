library(optparse)
cli <- function() {
  parser <- OptionParser()

  parser <- add_option(parser, "--counts", help="TSV file with gene counts")
  parser <- add_option(parser, "--scRef", help="RDA file with single cell reference counts")
  parser <- add_option(parser, "--scRef_sample", help="Column names of the samples in the reference data")
  parser <- add_option(parser, "--scRef_label", help="Column names of the cell types in the reference data")
  parser <- add_option(parser, "--output-prefix", default="", dest="output", help="Prefix for the output files")

  opt <- parse_args(parser)

  # Check for missing options
  if (is.null(opt$counts)) {
    stop("--counts is required")
  }
  if (is.null(opt$scRef)) {
    stop("--scRef is required")
  }

  if(is.null(opt$scRef_label)) {
    warning("--scRef_label is not defined using default: label.new")
    opt$scRef_label <- "label.new"
  }

  if(is.null(opt$scRef_sample)) {
    warning("--scRef_sample is not defined using default: Sample")
    opt$scRef_sample <- "Sample"
  }

  return(opt)
}

main <- function(options) {
  suppressMessages(library(seAMLess))

  # Printing function
  verbose <- TRUE
  verbosePrint <- verboseFn(verbose)

  verbosePrint(">> Loading libraries...")
  suppressMessages(library(xbioc))

  verbosePrint(">> Reading ", options$counts, "...")
  counts <- read.table(options$counts)

  verbosePrint(">> Reading ",options$scRef, "...")
  load(file=options$scRef)

  res <- seAMLess::seAMLess(counts, scRef, scRef.label = options$scRef_label, scRef.sample = options$scRef_sample)

  verbosePrint(">> Writing output...")
  write.table(res$Deconvolution, paste(options$output, "celltypes.tsv", sep=""), sep="\t", quote=FALSE)
  write.table(res$Venetoclax.resistance, paste(options$output, "venetoclax.tsv", sep=""), sep="\t", quote=FALSE)
  verbosePrint(">> Done")
}

opt <- cli()
main(opt)
