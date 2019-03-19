#' @export
db_ConnParams_RiskData      <-  list(odbc::odbc(),
                                     driver    = "SQL Server",
                                     server    = "prdps-dbfmep-1",
                                     database  = "RiskData",
                                     trustConn = "True" )


#' @export
udfMap_RiskData             <-  data.frame(
  
                                  name  = c("udf_cQuant_genAsset_CoalUnitThermalContent()",
                                            "udf_cQuant_FuelBlendComponents()",
                                            "udf_cQuant_genAsset_HeatRateCoefficients()",
                                            "udf_cQuant_genAsset_MustRunPeriods()",
                                            "udf_cQuant_genAsset_PlannedOutages()",
                                            "udf_cQuant_genAsset_UnitCharacteristics()",
                                            "udf_cQuant_genAsset_ListOfUniqueAssets()",
                                            "udf_cQuant_PeakPeriodDefinitions()"),
                                  
                                  alias = c("thermalContent",
                                            "fuelBlends",
                                            "hrCoefficients",
                                            "mustRunPrds",
                                            "plannedOutages",
                                            "unitCharacteristics",
                                            "uniqueAssets",
                                            "peakPeriods"),
                                  
                                  stringsAsFactors = FALSE )


#' @export
riskDataFilter_ProdVsTest   <- c(1)   #c(0,1)






