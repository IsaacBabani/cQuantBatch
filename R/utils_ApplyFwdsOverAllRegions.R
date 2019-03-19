utils_ApplyFwdsOverAllRegions    <- function(dfRaw, 
                                         datedFilePath, 
                                         cQuantSubfolder,
                                         regionList  = cQuantBatch:::rptRegions)
{
  uniqueItems <- dplyr::distinct(dfRaw, Variable)
  
  byItem      <- lapply(uniqueItems$Variable,
                       
                        function(item)
                        {
                          itemData  <- dplyr::filter(dfRaw, Variable == item)
                         
                          byRegion <- 
                           
                            lapply(regionList, 
                                  
                                    function(y)
                                    {
                                      writePath <- paste(datedFilePath,
                                                         y, 
                                                         cQuantSubfolder,
                                                         paste0(item, cQuantBatch:::fileWrite_FileExtension),
                                                         sep='/')
                                    
                                      utils_WriteDataToFile(itemData, writePath)
                                    }
                                  )
                        }
                       )
  
  return(all(byItem[[]]))
}