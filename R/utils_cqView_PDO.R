#' Function returns a recordset designed to mirror cQuant-style templates.
#' Unit characteristic, planned outage, fuel blend and must-run data is formatted
#'    and given column names required by cQuant data loader.
#'
#' Function takes a string that defines which cQuant template is being populated.
#'
#' @author Isaac Babani, \email{isaac.babani@talenenergy.com}
#' @param alias    String: the alias of the dataset to reformat
#' @param dfRaw    Dataframe: containing the raw database output in standard format
#'
#' @export
#' @return Dateframe: database results configure to match cQuant data format
utils_cqView_PDO  <- function(dfRaw, 
                              alias, 
                              date_SimStart = Sys.Date())
{
    if (grepl("UnitCharacteristics", alias, ignore.case = TRUE))
    { return(utils_cqView_PDO_UnitCharacteristics(dfRaw, date_SimStart))}
    
    else if (grepl("PlannedOutages", alias, ignore.case = TRUE))
    { return(utils_cqView_PDO_PlannedOutages(dfRaw, date_SimStart))}
    
    else if (grepl("MustRunPrds", alias, ignore.case = TRUE))
    { return(utils_cqView_PDO_MustRunPrds(dfRaw, date_SimStart))}
  
    else if (grepl("FuelBlends", alias, ignore.case = TRUE))
    { return(utils_cqView_PDO_FuelBlends(dfRaw))}  
  
    else if (grepl("PeakPeriods", alias, ignore.case = TRUE))
    { return(utils_cqView_PDO_PeakPeriods(dfRaw))}  
  

}