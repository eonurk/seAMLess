#' Command Line Interface for seAMLess
#'
#' Provides a command line interface to run seAMLess deconvolution analysis
#' on bulk RNA-seq data.
#'
#' @name cli
#' @return List of parsed command line options
#' @export
#' @examples
#' \dontrun{
#' # Run from command line:
#' Rscript cli.R --counts counts.tsv --scRef reference.rda --output-prefix results_
#' }
library(optparse)


#' Parse command line arguments
#' @return List of validated command line options
cli <- function() {
  parser <- OptionParser()

  parser <- add_option(parser, "--counts", help = "CSV file with gene counts")
  parser <- add_option(parser, "--scRef", help = "RDA file with single cell reference counts")
  parser <- add_option(parser, "--scRef_sample", default = "Sample",
                      help = "Column name for samples in reference data (default: Sample)")
  parser <- add_option(parser, "--scRef_label", default = "label.new",
                      help = "Column name for cell types in reference data (default: label.new)")
  parser <- add_option(parser, "--output-prefix", default = "", dest = "output",
                      help = "Prefix for output files")

  opt <- parse_args(parser)

  # Check for missing options
  if (is.null(opt$counts)) {
    stop("--counts is required")
  }
  if (is.null(opt$scRef)) {
    stop("--scRef is required")
  }

  # Remove warnings for default values
  if (is.null(opt$scRef_label)) {
    opt$scRef_label <- "label.new"
  }

  if (is.null(opt$scRef_sample)) {
    opt$scRef_sample <- "Sample"
  }

  return(opt)
}

main <- function(options) {

  # Printing function
  verbose <- TRUE
  verbosePrint <- seAMLess::verboseFn(verbose)

  verbosePrint(">> Loading libraries...")
  suppressMessages(library(xbioc))
  suppressMessages(library(seAMLess))

  verbosePrint(">> Reading ", options$counts, "...")
  counts <- data.table::fread(options$counts, data.table = FALSE)

  verbosePrint(">> Reading ", options$scRef, "...")
  load(file = options$scRef)
  
  verbosePrint(">> Running seAMLess...")
  res <- seAMLess(counts, scRef, scRef.label = options$scRef_label, scRef.sample = options$scRef_sample)

  verbosePrint(">> Writing output...")
  write.table(res$Deconvolution, paste(options$output, "celltypes.tsv", sep = ""), sep = "\t", quote = FALSE)
  write.table(res$Venetoclax.resistance, paste(options$output, "venetoclax.tsv", sep = ""), sep = "\t", quote = FALSE)
  verbosePrint(">> Done")
}

# Only run CLI if script is being executed directly (not during package installation)
if (sys.nframe() == 0 && interactive() == FALSE) {
  opt <- cli()
  main(opt)
}
