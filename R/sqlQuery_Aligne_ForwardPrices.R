sqlQuery_Aligne_ForwardPrices <- function(rptDate, nextDelDate, lastDelDate)
{
    qryString   <- "WITH X AS (SELECT DATE ':rptDate' PRICEDATE FROM DUAL)
                    SELECT CURVENAME, 
                           TO_CHAR(MATURITY,'yyyy-mm-dd') MATURITY, 
                           'Ltl' PARNAME,
                           ROUND(PX_ATC, 5) PX_ATC, 
                           ROUND(NVL(PX_PK, PX_ATC), 5) PX_PK, 
                          ROUND(NVL(PX_OP, PX_ATC), 5) PX_OP
                    FROM 
                      ( SELECT PK.KEY_PRICEDATE, PK.MKT || '_' || PK.COMP CURVENAME, 
                          PK.MATURITY, ((PK.PRICE * HR.PEAKHOURS) +
                          (OP.PRICE * HR.OFFPKHOURS))/(HR.PEAKHOURS + HR.OFFPKHOURS) PX_ATC,
                          PK.PRICE PX_PK, OP.PRICE PX_OP
                        FROM   
                          ( SELECT * FROM RISK.CQPRICES 
                            WHERE PRD = 'ONPEAK' 
                              AND KEY_PRICEDATE = (SELECT PRICEDATE FROM X)) PK,
                          ( SELECT * FROM RISK.CQPRICES 
                            WHERE PRD = 'OFFPEAK' 
                              AND KEY_PRICEDATE = (SELECT PRICEDATE FROM X)) OP,
                          RISK.CQHOURCNTS HR
                    WHERE PK.MKT = OP.MKT AND PK.COMP = OP.COMP 
                      AND PK.MATURITY = OP.MATURITY
                      AND  PK.MKT = HR.MKT 
                      AND PK.MATURITY = HR.DELMONTH
                    UNION ALL
                      SELECT PX.KEY_PRICEDATE, PX.MKT || '_' || PX.COMP CURVENAME, PX.MATURITY, 
                        CASE 
                          WHEN MRK.MRKTC_TYPE IN ('O','Q') THEN PX.PRICE * MRK.MRKTC_LINELOSS
                          ELSE PX.PRICE
                        END PRICE, NULL PX_PK, NULL PX_OP
                      FROM RISK.CQPRICES PX 
                      JOIN MRKTC MRK
                        ON MRK.MRKTC_MKT = PX.MKT 
                          AND MRK.MRKTC_COMP = PX.COMP 
                          AND MRK.MRKTC_AOHM > SYSDATE
                      WHERE  PX.PRD = 'ATC' 
                        AND REGEXP_LIKE(PX.MKT, '^GDA|^NYMEX|^IFERC|^COAL','i')
                        AND  KEY_PRICEDATE = (SELECT PRICEDATE FROM X)
                    UNION ALL
                      SELECT ANOX.KEY_PRICEDATE, 'emissions_NOx' CURVENAME, 
                        ANOX.MATURITY,
                        CASE WHEN EXTRACT(MONTH FROM ANOX.MATURITY) BETWEEN 5 AND 9 
                          THEN ANOX.PRICE + NVL(SNOX.PRICE, 0)
                        ELSE ANOX.PRICE END PX_ATC,
                        NULL PX_PK, NULL PX_OP
                      FROM 
                        ( SELECT * FROM RISK.CQPRICES 
                          WHERE MKT = 'NOX' AND COMP = ':aNoxComp' 
                            AND KEY_PRICEDATE = (SELECT PRICEDATE FROM X)) ANOX
                      LEFT JOIN 
                        ( SELECT * FROM RISK.CQPRICES 
                          WHERE MKT = 'NOX' AND COMP = ':sNoxComp' 
                            AND KEY_PRICEDATE = (SELECT PRICEDATE FROM X)) SNOX
                      ON ANOX.MKT = SNOX.MKT AND ANOX.MATURITY = SNOX.MATURITY
                    UNION ALL
                      SELECT KEY_PRICEDATE, DECODE(MKT || COMP, 'SO2' || 'GP1Y19', 
                        'emissions_SOx', 'RGGI' || ':fourDigitYr', 'emissions_CO2') CURVENAME,
                        MATURITY, PRICE PX_ATC, NULL PX_PK, NULL PX_OP
                      FROM   RISK.CQPRICES
                      WHERE  (MKT, COMP) IN (('SO2', ':soxComp'), ('RGGI', ':fourDigitYr'))
                        AND  KEY_PRICEDATE = (SELECT PRICEDATE FROM X))
                    WHERE MATURITY BETWEEN DATE ':nextDelDate' AND DATE ':lastDelDate'"

    qryString    <- gsub(":rptDate",     rptDate,     qryString)
    qryString    <- gsub(":nextDelDate", nextDelDate, qryString)
    qryString    <- gsub(":lastDelDate", lastDelDate, qryString)
    
    twoDigitYr   <- format(nextDelDate, "%y")
    fourDigitYr  <- format(nextDelDate, "%Y")
    qryString    <- gsub(":fourDigitYr", fourDigitYr,                qryString)
    qryString    <- gsub(":aNoxComp",    paste0('ANLY', twoDigitYr), qryString)
    qryString    <- gsub(":sNoxComp",    paste0('SNLY', twoDigitYr), qryString)
    qryString    <- gsub(":soxComp",     paste0('GP1Y', twoDigitYr), qryString)

    #create connection object
    dbConnection <- do.call(DBI::dbConnect, db_ConnParams_Aligne)

    #execute procedure and store results
    results      <- DBI::dbGetQuery(dbConnection, qryString)

    #close connection
    DBI::dbDisconnect(dbConnection)

    return( results )
}
