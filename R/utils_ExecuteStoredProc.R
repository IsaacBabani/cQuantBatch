#' Function takes a string that is an alias to the name of the stored procedure.
#'  Use the allias so parameter is more conveniently named - the proc names are unwieldy. 
#' Ellipsis allows the user to pass a variable number of arguments representing
#'   the stored procedure's parameters.
#' It then executes a named stored procedure and returns a dataframe.
#' Lastly, connection to the database is closed to prevent memory leak.
#'
#' @author Isaac Babani, \email{isaac.babani@talenenergy.com}
#' @param storedProcAlias  String: the alias of the stored procedure to execute
#' @param ...              String: variable number of parameters that can be passed to the stored proc.
#' @param databaseName     String: name of the database being accessed
#'      Default is db_ConnParams_RiskData database as defined in constants_PlantData.R file.
#'
#' @export
#' @return Dateframe: results from database
utils_ExecuteStoredProc  <- function(storedProcAlias,
                                     ...,
                                     databaseName = db_ConnParams_RiskData)
{
    #build string containing procedure name and parameters
    #get procuedure full name from short alias. Alias is case insensitive.
    storedProcName <- procMap_RiskData %>%
                        dplyr::filter(grepl(storedProcAlias, procAlias, ignore.case=TRUE)) %>%
                        dplyr::select(procName)

    if (nrow(storedProcName) == 0) { stop("Invalid procedure name.") }

    procString     <- paste("exec",storedProcName)
    #this line is used to add the comma separating the stored proc parameters
    params         <- paste(..., sep=',')
    procString     <- paste(procString, params)

    #create connection object
    dbConnection   <- try(do.call(DBI::dbConnect, databaseName))

    #execute procedure and store results
    results        <- DBI::dbGetQuery(dbConnection, procString)

    #close connection
    DBI::dbDisconnect(dbConnection)

    return( results )
}
