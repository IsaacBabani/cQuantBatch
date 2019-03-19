writeRiskDataByIsoToFolder <-  function(dfRiskData, 
                                        isoName, 
                                        datedFilePath,
                                        subfolderName)
{
    writePath <- paste(datedFilePath,
                       subfolderName,
                       paste0(isoName, cQuantBatch:::fileWrite_FileExtension),
                       sep='/')

   utils_WriteDataToFile(dfRiskData, writePath)
}