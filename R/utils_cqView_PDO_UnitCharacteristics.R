#' Function returns a dataframe containing unit characteristics in cQuant format.
#'
#' @author Isaac Babani, \email{isaac.babani@talenenergy.com}
#' @param dfRaw   Dataframe: containing the raw database output in standard format
#'
#' @export
#' @return Dateframe: database results configure to match cQuant data format

utils_cqView_PDO_UnitCharacteristics  <- function(dfRaw, date_SimStart = Sys.Date())
{
    dfNew  <-
      
      #to filter relevant dates, first need to create a date object from month and year fields
      dplyr::mutate(dfRaw, FullDate = as.Date(paste(Year, Month, 1, sep='-')))  %>%
      dplyr::filter(FullDate >= date_SimStart)  %>%
      dplyr::select(-FullDate)  %>%
      
      #exclude columns not required by cQuant
      dplyr::mutate(EnvironmentalCostAdder = EnvironmentalCostAdder + LmpAdder) %>%
      dplyr::select(-isProd, -StartupFuelName, -LmpAdder)      %>%
      
      
      #Ultimately, dual-fuel plants (e.g. BrunnerIsland) will take 2 records per month (1 set of UC per fuel)
      #Currently, cQuant cannot take >1 record per unit per month
      #To adjust, we pass the details for the most probable fuel for each month (gas in the summer, coal in the winter)
      #Below filters are applied to only pass data for the most likely fuel for each month
      dplyr::filter(!( plantName == "BrunnerIsland" &
                       FuelCommodity == "Gas" &
                       !dplyr::between(Month, 3, 11)))         %>%
      
      dplyr::filter(!( plantName == "BrunnerIsland" &
                         FuelCommodity == "Coal" &
                         dplyr::between(Month, 3, 11)))        %>%
    
      #rename columns to precisely match cQuant names
      dplyr::rename(UnitName           = unitName,
                    Subportfolio       = plantName,
                    Region             = iso,
                    HotStartCostFixed  = HotStartFixedCost,
                    WarmStartCostFixed = WarmStartFixedCost,
                    ColdStartCostFixed = ColdStartFixedCost )  
      
    #Wagner 2 ceases operations at the end of May 2020.  CQ requires monthly data be input for periods in the analysis.
    #To handle this, the last record (May 2020) is copied and repeated enough times to reach the terminal month of analysis.
    #Additionally, the unit is placed on planned outage commencing 01JUN20. This is handled directly in the DB tables.
    reqdRows  <- NROW(dplyr::filter(dfNew, UnitName == 'HAWagner_2'))
    wag2      <- dplyr::filter(dfNew, UnitName == 'HAWagner_2')
    rowsTAdd  <- reqdRows - NROW(wag2)
    lastW2    <- tail(wag2,1)
    w2New     <- lastW2[rep(seq_len(nrow(lastW2)), each=rowsTAdd),]
    
    #add back correct set of year/month combinations
    lastDt    <- dplyr::select(lastW2, Year, Month)
    yrMon     <- dplyr::filter(wag2, (Year > lastDt$Year) | (Year == lastDt$Year & Month > lastDt$Month)) %>%
      dplyr::select(Year, Month)
    
    w2New     <- dplyr::mutate(w2New, Year = yrMon$Year, Month = yrMon$Month)
    
    #append to original data set
    dfNew     <- rbind(dfNew, w2New)                           %>%
                    dplyr::arrange(Region, UnitName, Year, Month)
    
    return(dfNew)
}
