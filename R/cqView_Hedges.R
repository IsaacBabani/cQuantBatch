cqView_Hedges  <- function(rptDate,
                           datedFilePath,
                           regionList = cQuantBatch:::rptRegions)
{
    hedges   <- sqlQuery_Aligne_HedgeTrades(rptDate)                           %>%
                  dplyr::rename(DealID       = DEALID, 
                                Description  = DESCRIPTION,
                                DealType     = DEALTYPE,
                                Subportfolio = SUBPORTFOLIO,
                                Region       = REGION,
                                Counterparty = COUNTERPARTY,
                                HeatRate     = HEATRATE,
                                Cost         = COST,
                                Currency     = CURRENCY,
                                StartDate    = STARTDATE,
                                EndDate      = ENDDATE,
                                Volume       = VOLUME,
                                DelFreq      = DELFREQ,
                                StrikePrice  = STRIKEPRICE,
                                Premium      = PREMIUM,
                                Option       = XOPTION,
                                Position     = POSITION,
                                PeakPeriod   = PEAKPERIOD,
                                MarketCurve1 = MARKETCURVE1,
                                MarketCurve2 = MARKETCURVE2)                   %>%
                  dplyr::mutate(Region = dplyr::case_when( grepl(inMeneRegion, 
                                                                 Region, 
                                                                 ignore.case = TRUE ) ~ rptRegions[['me']],
                                                           TRUE ~ Region),
                                MarketCurve1 = gsub('IFERC','GDA', MarketCurve1, fixed = TRUE),
                                MarketCurve2 = gsub('IFERC','GDA', MarketCurve1, fixed = TRUE))
    
    
    byRegion <- lapply(regionList, 
                       
                       function(y)
                       {
                         isoFilter <- dplyr::filter(hedges, grepl(y, Region, ignore.case = TRUE))
                         
                         if (NROW(isoFilter) > 0 )
                         {
                             writePath <- paste(datedFilePath,
                                                y, 
                                                IOFileFolderList[["hedges"]],
                                                paste0(y, cQuantBatch:::fileWrite_FileExtension),
                                                sep='/')
                             
                             writeData <- utils_WriteDataToFile(isoFilter,writePath)
                         }
                       }
                      )
   
  
}
