queryAndFilterRiskDataByRegion <- function(rptAlias, 
                                           date_SimStart = Sys.Date(),
                                           regionList    = cQuantBatch:::rptRegions)
{
  fcnName  <- udfMap_RiskData %>%
                dplyr::filter(grepl(rptAlias, alias, ignore.case=TRUE)) %>%
                dplyr::select(name) 
            
  dfRaw    <- sqlQuery_AllTableRecords(fcnName)   %>%
                dplyr::filter(isProd %in% cQuantBatch:::riskDataFilter_ProdVsTest) %>%
                dplyr::mutate(iso = dplyr::case_when(grepl(inMeneRegion,
                                                           iso, 
                                                           ignore.case = TRUE ) ~ rptRegions[['me']],
                                                     TRUE ~ iso) )                
  
  
  byRegion <- lapply(regionList, 
                     
                     function(region)
                     {
                        isoFilter <- if(grepl('fuelBlends', rptAlias, ignore.case = TRUE))
                                      {dfRaw}
                                     else
                                            {dplyr::filter(dfRaw, grepl(region,iso, ignore.case = TRUE))}

                        cqView    <- utils_cqView_PDO(isoFilter, rptAlias, date_SimStart) 
                     }
                    )
  
  return(byRegion)
}