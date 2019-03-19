#' Function returns a dataframe containing fuel blend data in cQuant format.
#'
#' @author Isaac Babani, \email{isaac.babani@talenenergy.com}
#' @param dfRaw   Dataframe: containing the raw database output in standard format
#'
#' @export
#' @return Dateframe: database results configure to match cQuant data format

utils_cqView_PDO_FuelBlends  <- function(dfRaw)
{
  dfNew  <-
    
    #exclude columns not required by cQuant
    dplyr::select(dfRaw, -fuelCommodity, -isProd)   %>%
    
    #rename columns to precisely match cQuant names
    dplyr::rename(BlendName      = fuelCurveName,
                  BlendComponent = componentName,
                  Percentage     = componentPercentage )
  
  
  return(dfNew)
}
