#' Function returns a dataframe containing planned outages in cQuant format.
#'
#' @author Isaac Babani, \email{isaac.babani@talenenergy.com}
#' @param dfRaw   Dataframe: containing the raw database output in standard format
#'
#' @export
#' @return Dateframe: database results configure to match cQuant data format

utils_cqView_PDO_PlannedOutages  <- function(dfRaw, 
                                             date_SimStart = Sys.Date())
{
  dfNew  <-
    
    dplyr::filter(dfRaw, StartDate >= date_SimStart)  %>%
    
    #exclude columns not required by cQuant
    dplyr::select(-plantName, -iso, -isProd)          %>%
    
    #rename columns to precisely match cQuant names
    dplyr::rename(UnitName      = unitName,
                  OutagePercent = outagePercentage )
  
  return(dfNew)
}
