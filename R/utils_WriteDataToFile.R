#' Function writes a data set (data frame) to a CSV file.
#' Use this function to avoid setting all the parameters to the fwrite function.
#'
#' @author Isaac Babani, \email{isaac.babani@talenenergy.com}
#'
#' @param dataSet       Dataframe: containing the data being written to the file
#' @param fullFilePath  String: the fulll file path including file name and extension (i.e. file type)
# @param fileName      String: the file name (appended to the fileRoot)
# @param fileRoot      String: the file path root
#' @param fileExtension String: the file type (e.g. .csv, .txt)
#' @param append        Boolean: append to existing file data.
#' @param col.names     Boolean: do we write the column names
#' @param row.names     Boolean: do we write the row names
#' @param sep           String: the file delimiter
#' @param showProgress  Boolean: show progress as file is being written
#'
#' @export
#'
#' @return TRUE if executed successfully
#'
utils_WriteDataToFile <- function(dataSet,
                                  fullFilePath,
                                  append        = cQuantBatch:::fileWrite_DoAppend,
                                  col.names     = cQuantBatch:::fileWrite_ColNames,
                                  row.names     = cQuantBatch:::fileWrite_RowNames,
                                  sep           = cQuantBatch:::fileWrite_Delimiter,
                                  showProgress  = cQuantBatch:::fileWrite_ShowProgress)
      {

  #create the directory (and required subfolders) specified in filePath argument if doesn't already exist
  fileRoot    <- paste0(dirname(fullFilePath),'/')
  dir.create(fileRoot, showWarnings = FALSE, recursive = TRUE)

  data.table::fwrite(x            = dataSet,
                     file         = fullFilePath,
                     append       = append,
                     col.names    = col.names,
                     sep          = sep,
                     showProgress = showProgress)

  return(TRUE)
}
