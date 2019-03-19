calculateShockedForwards <- function(fwds, 
                                     shift_Power = delta_ShiftPower, 
                                     shift_Fuel  = delta_ShiftFuel)
{
    dfNew <- fwds %>%
      
              dplyr::mutate(PX_ATC = dplyr::case_when(grepl('^GDA|^NYMEX|^IFERC|^COAL', 
                                                            CURVENAME, 
                                                            ignore.case = TRUE) ~ PX_ATC + shift_Fuel,
                                                      
                                                      grepl('^emissions', 
                                                            CURVENAME, 
                                                            ignore.case = TRUE) ~ PX_ATC,
                                                      
                                                      TRUE ~ PX_ATC + shift_Power),
                            
                            
                            PX_PK = dplyr::case_when(grepl('^GDA|^NYMEX|^IFERC|^COAL', 
                                                            CURVENAME, 
                                                            ignore.case = TRUE) ~ PX_PK + shift_Fuel,
                                                      
                                                      grepl('^emissions', 
                                                            CURVENAME, 
                                                            ignore.case = TRUE) ~ PX_PK,
                                                      
                                                      TRUE ~ PX_PK + shift_Power),
                            
                            PX_OP = dplyr::case_when(grepl('^GDA|^NYMEX|^IFERC|^COAL', 
                                                            CURVENAME, 
                                                            ignore.case = TRUE) ~ PX_OP + shift_Fuel,
                                                      
                                                      grepl('^emissions', 
                                                            CURVENAME, 
                                                            ignore.case = TRUE) ~ PX_OP,
                                                      
                                                      TRUE ~ PX_OP + shift_Power) )
  
    return( dfNew )
}