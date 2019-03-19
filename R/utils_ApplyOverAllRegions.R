utils_ApplyOverAllRegions    <- function(dfRaw, 
                                         idField, 
                                         datedFilePath, 
                                         cQuantSubfolder,
                                         regionList  = cQuantBatch:::rptRegions)
{
  uniqueItems <- dplyr::distinct(dfRaw, get(idField))
  
  dd <- uniqueItems$get(idField)
  byItem      <- lapply(dd,
                       
                        function(item)
                        {
                          itemData  <- dplyr::filter(dfRaw, idField == item)
                         
                          byRegion <- 
                           
                            lapply(regionList, 
                                  
                                    function(y)
                                    {
                                      writePath <- paste(datedFilePath,
                                                         y, 
                                                         cQuantSubfolder,
                                                         paste0(item, cQuantBatch:::fileWrite_FileExtension),
                                                         sep='/')
                                    
                                      print(writePath)
                                      #utils_WriteDataToFile(itemData, writePath)
                                    }
                                  )
                        }
                       )
  
  return(all(byItem[[]]))
}