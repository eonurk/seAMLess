#' Given the count matrices of bulk-RNA samples, this function deconvolutes
#' each sample into its cell types using a healthy BM reference, and
#' calculates the sample's in vitro resistance to Venetoclax.
#'
#' @param mat count matrix (genes by 1+samples).
#' @param verbose prints detailed messages
#'
#' @return List of deconvoluted cell type percentages and predicted drug resistances
#' @export

seAMLess <- function(mat, verbose = TRUE) {

    requireNamespace("randomForest", quietly = T)

    # Printing function
    verbosePrint <- verboseFn(verbose)

    # wrangle count matrix
    mat <- wrangleMat(mat)

    # If ensembl ids are provided
    if(grepl("ENSG", rownames(mat)[1], fixed = TRUE)){

        # ens to symbol map
        ens2gene <- seAMLess::grch38
        m <- match(rownames(mat), ens2gene$ensgene)
        mapped.genes <- ens2gene$symbol[m]
        # duplicated name/NA/mitochondrial genes
        removed.genes <- duplicated(mapped.genes) | is.na(mapped.genes) | grepl("^MT", mapped.genes)

        mat <- mat[!removed.genes,]
        rownames(mat) <- mapped.genes[!removed.genes]

        verbosePrint(">> Human ensembl ids are converted to symbols...")
    }

    # make mat suitable for MuSiC
    T.eset <- Biobase::ExpressionSet(assayData = as.matrix(mat))

    verbosePrint(">> Deconvoluting samples...")
    # MusiC deconvolution
    deconv <- MuSiC::music_prop(bulk.eset = T.eset, sc.eset = seAMLessData::scRef,
                                clusters = 'label.new',
                                markers = NULL, normalize = FALSE, samples = 'Sample',
                                verbose = F)$Est.prop.weighted
    verbosePrint(">> Deconvolution completed...")


    verbosePrint(">> Predicting Venetoclax resistance...")
    veno.res <- stats::predict(seAMLess::venoModel, newdata = deconv)
    verbosePrint(">> Done...")
    return(list(Deconvolution = deconv, Venetoclax.resistance = veno.res))

}
