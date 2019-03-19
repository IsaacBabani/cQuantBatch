cqView_SpotData <- function(dfRaw)
{
  dfNew <-  dfRaw %>%
            
              dplyr::mutate( DateTime = as.POSIXct(DateTime, format="%m/%d/%Y %H:%M", tz="UTC"), 
                             DateTime = DateTime - lubridate::dhours(0), #add variable to control adjustment for HE vs HB
                             Date = lubridate::date(DateTime),
                             Hour = factor(paste0('X', lubridate::hour(DateTime) + 1),
                                            levels=paste0('X', 1:24)) ) %>% 

              dplyr::select( Variable = crvName, DateTime, Price, Date, Hour )
  
  
  hours <- dplyr::data_frame( 
              DateTime = seq.POSIXt( min(dfNew$DateTime), 
                                     max(dfNew$DateTime), 
                                     by='hour'))
  
  
  data <- hours %>%
              dplyr::left_join(dfNew, by='DateTime' ) %>%
              tidyr::fill( Price ) %>%
              dplyr::select( -DateTime ) %>%
              dplyr::distinct( Variable, Date, Hour, .keep_all=TRUE ) %>% # Remove dups.
              tidyr::spread( key=Hour, value=Price ) %>%
              dplyr::mutate( Variable = gsub(' ', '_', Variable),
                             Variable = gsub('[.]', '_', Variable) )
  
  return(data)
  
}