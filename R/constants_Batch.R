#' @export
minSimMonths      <- 48

#' @export
delta_ShiftPower  <- 1.0

#' @export
delta_ShiftFuel   <- 0.1

#' @export
rootDirectory     <- "T:/Marketing/Analysis/PortfolioAnalysis/GrossMarginReports/Risk Reporting/Projects/Isaac/cQuant"

#' @export
email_from        <- "<TalencQuantAnalytics@talenenergy.com>"

#' @export
email_to          <- c("<TalencQuantAnalytics@talenenergy.com>")

#' @export
email_smtp        <- list(host.name = "Mailhub.Corp.TalenEnergy.com", 
                          port      = 25, 
                          ssl       = FALSE)

#' @export
email_send        <- TRUE

#' @export
rptRegions        <- c(er = "ercot", 
                       me = "mene", 
                       pj = "pjm")

#' @export
inMeneRegion      <- 'isone|nyiso|west'  
