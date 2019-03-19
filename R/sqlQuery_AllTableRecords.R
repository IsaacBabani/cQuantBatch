sqlQuery_AllTableRecords <- function(tableName, 
                                     db_ConnParms = db_ConnParams_RiskData)
{
  qryString   <- "select * from :tableName"
  qryString   <- gsub(":tableName", tableName, qryString)
    
  #create connection object
  dbConnection <- do.call(DBI::dbConnect, db_ConnParms)

  #execute procedure and store results
  results      <- DBI::dbGetQuery(dbConnection, qryString)

  #close connection
  DBI::dbDisconnect(dbConnection)

  return( results )

}
