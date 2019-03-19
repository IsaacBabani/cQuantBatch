queryRiskDataUDF <-  function(rptAlias)
{
    fcnName  <- udfMap_RiskData %>%
                  dplyr::filter(grepl(rptAlias, 
                                      alias, 
                                      ignore.case=TRUE)) %>%
                  dplyr::select(name) 

    dfRaw    <- sqlQuery_AllTableRecords(fcnName)  %>%
                  dplyr::filter(isProd %in% cQuantBatch:::riskDataFilter_ProdVsTest) %>%
                  dplyr::mutate(iso = dplyr::case_when(grepl(inMeneRegion,
                                                              iso, 
                                                              ignore.case = TRUE ) ~ rptRegions[['me']],
                                                       TRUE ~ iso) )

    return(dfRaw)
}