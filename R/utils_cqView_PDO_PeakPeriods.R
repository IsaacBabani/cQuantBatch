#' Function returns a dataframe containing peak period data in cQuant format.
#'
#' @author Isaac Babani, \email{isaac.babani@talenenergy.com}
#' @param dfRaw   Dataframe: containing the raw database output in standard format
#'
#' @export
#' @return Dateframe: database results configure to match cQuant data format

utils_cqView_PDO_PeakPeriods  <- function(dfRaw)
{
  dfNew  <-
    
    #exclude columns not required by cQuant
    dplyr::select(dfRaw, -iso, -isProd)      %>%
    
    #rename columns to precisely match cQuant names
    dplyr::rename(Day = dayOfWeek)           %>%
    
    #make wide view from long
    tidyr::spread(hourEnded, inPeriod, fill = 0)
  
  
  return(dfNew)
}
