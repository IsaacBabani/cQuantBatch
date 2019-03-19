#' @export
IOFileFolderList      <- c(calib    = 'APS_CALIBRATION',
                           fwds     = 'APS_FORWARDLIST',
                           simCOnf  = 'APS_INFOFILE',
                           spotHist = 'APS_SPOTINFOLIST',
                           pkPrds   = 'C_PEAKPERIODFILE',
                           hedges   = 'CFAR_CONTRACTFILE',
                           emitCO2  = 'PDO_CO2PRICEFILE',
                           blends   = 'PDO_FUELBLENDFILE',
                           mustRun  = 'PDO_MUSTRUNPERIODFILE',
                           emitNOX  = 'PDO_NOXPRICEFILE',
                           outages  = 'PDO_PLANNEDOUTAGEFILE',
                           plantUC  = 'PDO_PLANTFILE',
                           renewGen = 'PDO_RENEWABLEGENFILE',
                           renewPar = 'PDO_RENEWABLEPARAMETERS',
                           emitSOX  = 'PDO_SOXPRICEFILE')
#' @export
subfolder_OutToCQ     <- 'TO_CQUANT'

#' @export
subfolder_InFromCQ    <- 'FROM_CQUANT'

#' @export
subfolder_IOTemplate  <- 'CQ_FILE_STRUCTURE'