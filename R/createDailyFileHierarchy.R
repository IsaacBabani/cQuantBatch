createDailyFileHierarchy <- function(datedPath_TOCQUANT,
                                     fileRoot             = cQuantBatch:::rootDirectory,
                                     subfolder_IOTemplate = cQuantBatch:::subfolder_IOTemplate)
{

    templatePath      <- paste(fileRoot, 
                               subfolder_IOTemplate,
                               sep = '/')
    
    templateFolders   <- list.dirs(templatePath, 
                                   full.names = TRUE, 
                                   recursive  = FALSE)
    
    foldersCreated    <- 
      
        lapply(templateFolders,
           
                function(x)
                {
                  print(paste0(datedPath_TOCQUANT,'/'))
                  file.copy(x, 
                            paste0(datedPath_TOCQUANT,'/'), 
                            recursive = TRUE)
                }
              ) 
  
    return(all(foldersCreated[[]]))

}