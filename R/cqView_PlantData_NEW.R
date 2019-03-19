cqView_PlantData_NEW   <- function(date_SimStart, 
                                   datedFilePath, 
                                   regionList = cQuantBatch:::rptRegions)
{
    pdoDataList    <- c(uc = "unitCharacteristics", 
                        po = "plannedOutages",
                        mr = "mustRunPrds", 
                        pp = "peakPeriods")
  
    qryResults     <- queryAndFilterRiskDataByRegion(pdoDataList[['uc']], date_SimStart)
      
    
    
}