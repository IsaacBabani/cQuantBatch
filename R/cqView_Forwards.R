cqView_Forwards  <- function(rptDate, 
                             nextDelDate, 
                             lastDelDate,
                             datedFilePath, 
                             regionList  = cQuantBatch:::rptRegions,
                             doCalcDelta = FALSE, 
                             shift_Power = delta_ShiftPower,
                             shift_Fuel  = delta_ShiftFuel)
{
    forwards   <- sqlQuery_Aligne_ForwardPrices(rptDate     = rptDate, 
                                                nextDelDate = nextDelDate, 
                                                lastDelDate = lastDelDate)      %>%
      
                    dplyr::mutate(MATURITY = sprintf('%d-%02d-XX XX:XX:XX',
                                                lubridate::year(MATURITY),
                                                lubridate::month(MATURITY)))    %>%
      
      
                    {if (doCalcDelta) 
                       calculateShockedForwards(., shift_Power, shift_Fuel) 
                     else . }                                                   %>%
      
                    dplyr::rename(Variable = CURVENAME,
                                  Date     = MATURITY,
                                  ParName  = PARNAME,
                                  Flat_Avg = PX_ATC,
                                  Peak_Avg = PX_PK,
                                  OffP_Avg = PX_OP)
   
    energyPx   <- dplyr::filter(forwards, !grepl('^emissions', Variable, ignore.case = TRUE))
    
    writeFwds  <- utils_ApplyFwdsOverAllRegions(dfRaw           = energyPx,
                                                datedFilePath   = datedFilePath,
                                                cQuantSubfolder = IOFileFolderList[["fwds"]],
                                                regionList      = cQuantBatch:::rptRegions)

    
    NOX        <- dplyr::filter(forwards,  Variable == 'emissions_NOx')
    
    writeFwds  <- utils_ApplyFwdsOverAllRegions(dfRaw           = NOX,
                                                datedFilePath   = datedFilePath, 
                                                cQuantSubfolder = IOFileFolderList[["emitNOX"]],
                                                regionList      = cQuantBatch:::rptRegions)
    
    SOX        <- dplyr::filter(forwards,  Variable == 'emissions_SOx')
    
    writeFwds  <- utils_ApplyFwdsOverAllRegions(dfRaw           = SOX,
                                                datedFilePath   = datedFilePath, 
                                                cQuantSubfolder = IOFileFolderList[["emitSOX"]],
                                                regionList      = cQuantBatch:::rptRegions)
    
    CO2        <- dplyr::filter(forwards,  Variable == 'emissions_CO2')
    
    writeFwds  <- utils_ApplyFwdsOverAllRegions(dfRaw           = CO2,
                                                datedFilePath   = datedFilePath, 
                                                cQuantSubfolder = IOFileFolderList[["emitCO2"]],
                                                regionList      = cQuantBatch:::rptRegions)

}
