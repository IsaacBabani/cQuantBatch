cqView_PlantData   <- function(date_SimStart, 
                               datedFilePath, 
                               regionList = cQuantBatch:::rptRegions)
{
    pdoDataList    <- c(uc = "unitCharacteristics", 
                        po = "plannedOutages",
                        mr = "mustRunPrds", 
                        pp = "peakPeriods")
  
    qryResults     <-
      
     lapply( pdoDataList, 
                          
             function(x)
             {
                fcnName  <- udfMap_RiskData %>%
                              dplyr::filter(grepl(x, alias, ignore.case=TRUE)) %>%
                              dplyr::select(name) 
                                
                dfRaw    <- sqlQuery_AllTableRecords(fcnName)  %>%
                              dplyr::filter(isProd %in% cQuantBatch:::riskDataFilter_ProdVsTest) %>%
                              dplyr::mutate(iso = dplyr::case_when( grepl(inMeneRegion,
                                                                          iso, 
                                                                          ignore.case = TRUE ) ~ rptRegions[['me']],
                                                                    TRUE ~ iso) )   
                                
                byRegion <- lapply(regionList, 
                                          
                                   function(y)
                                   {
                                      isoFilter <- dplyr::filter(dfRaw, grepl(y, iso, ignore.case = TRUE))
                                      
                                      cqView    <- utils_cqView_PDO(x, isoFilter, date_SimStart) 
                                      
                                      writePath <- paste(datedFilePath, 
                                                         x, 
                                                         paste0(y, cQuantBatch:::fileWrite_FileExtension),
                                                         sep='/')  
                                      
                                      utils_WriteDataToFile(cqView, writePath)
                                                     
                                    }
                                  )
                                
                              
             }  
           )
    
}