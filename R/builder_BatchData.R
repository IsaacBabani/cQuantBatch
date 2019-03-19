builder_BatchData <- function(rptDate)
{
    #calculate relevant dates
    date_Rpt         <- as.Date(rptDate, format=dateFormat_ISO)
    date_SimStart    <- as.Date(format(date_Rpt + months(1),"%Y-%m-01"))
    nMonthsForward   <- date_SimStart + months(cQuantBatch:::minSimMonths)
    date_SimEnd      <- as.Date(paste(lubridate::year(nMonthsForward),'12', '31', sep='-'))  
  
    #apply required formats to dates (i.e. Aligne DB uses dd-Mmm-yy)
    #dtStr_Run        <- format(date_Rpt, cQuantBatch:::dateFormat_AligneDB)
    #dtStr_SimStart   <- format(date_SimStart, cQuantBatch:::dateFormat_AligneDB)
    #dtStr_SimEnd     <- format(date_SimEnd, cQuantBatch:::dateFormat_AligneDB)
    
    #CREATE DAILY FILE SYSTEM FOR DATA SENT TO CQ
    str_RptDate      <- format(date_Rpt, cQuantBatch:::fileWrite_SuffixDateFormat)
    
    datedPath_TO     <- paste(cQuantBatch:::rootDirectory, 
                              cQuantBatch:::subfolder_OutToCQ, 
                              str_RptDate,
                              sep = '/')
    
    folder_Dated_TO   <- dir.create(paste0(datedPath_TO,'/'), 
                                    showWarnings = FALSE, 
                                    recursive    = FALSE)
    
    fileSystem        <- cQuantBatch::createDailyFileHierarchy(datedPath_TO)
    
    #CREATE DAILY FILE SYSTEM FOR DATA RECEIVED FROM CQ
    datedPath_FROM    <- paste(cQuantBatch:::rootDirectory, 
                               cQuantBatch:::subfolder_InFromCQ, 
                               str_RptDate,
                               sep = '/')
    
    folder_Dated_FROM <- dir.create(paste0(datedPath_FROM,'/'), 
                                    showWarnings = FALSE, 
                                    recursive    = FALSE)
    
    #pull forward prices from ALIGNE DB (RISK.CQPRICES) and write output files 
    forwards          <- cqView_Forwards(rptDate       = date_Rpt, 
                                         nextDelDate   = date_SimStart, 
                                         lastDelDate   = date_SimEnd,
                                         datedFilePath = datedPath_TO)
    
    #pull hedge trades from ALIGNE DB (RISK.RISKNONDECOND) and write output files 
    hedges            <- cqView_Hedges(rptDate       = date_Rpt, 
                                       datedFilePath = datedPath_TO)
    
    #pull plant data from RISKDATA DB (various genAsset_ tables) and write output files 
    #plantData        <- cqView_PlantData(date_SimStart, datedFilePath)
  
}