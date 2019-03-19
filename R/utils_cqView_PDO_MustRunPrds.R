#' Function returns a dataframe containing must-run periods in cQuant format.
#'
#' @author Isaac Babani, \email{isaac.babani@talenenergy.com}
#' @param dfRaw   Dataframe: containing the raw database output in standard format
#'
#' @export
#' @return Dateframe: database results configure to match cQuant data format
utils_cqView_PDO_MustRunPrds  <- function(dfRaw, date_SimStart)
{
  dfNew  <-
    
    dplyr::filter(dfRaw, StartDate >= date_SimStart)  %>%
    
    #exclude columns not required by cQuant
    dplyr::select(-plantName, -iso, -isProd)   %>%
    
    #rename columns to precisely match cQuant names
    dplyr::rename(UnitName = unitName )
  
  return(dfNew)
}
