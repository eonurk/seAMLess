library(optparse)

cli <- function() {
  parser <- OptionParser()

  parser <- add_option(parser, "--counts", help="TSV file with gene counts")
  parser <- add_option(parser, "--scRef", help="RDA file with single cell reference counts")

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

opt <- cli()

message("Hello, world!")

message(c(opt$counts," ", opt$scRef))
