sqlQuery_Aligne_HedgeTrades <- function(rptDate)
{
  qryString   <- "select z.zkey || '_' ||
                  case
                    when z.priceband = 'ON PEAK'  then 'ONPEAK'
                    when z.priceband = 'OFF PEAK' then 'OFFPEAK'
                    when z.priceband = 'WE PEAK' then 'WOFFPEAK'
                    when z.priceband = 'ATC' then 'ATC'
                    else z.priceband
                  end
                    || '_' || to_char(z.dmo,'MONYY') DealID,
                  trim(z.talentemplate) Description,
                  trim(z.risk_businessunit) Subportfolio,
                  case
                    when lower(trim(z.Region)) = 'montana' then 'west'
                    else lower(trim(z.Region))
                  end Region,
                  case
                    when lower(z.talentemplate) in ('coal physicals',
                                                    'gas fixed physicals',
                                                    'gas fixed swaps',
                                                    'power fixed physicals',
                                                    'power index physicals',
                                                    'power fixed swaps') then 'Swap'
                    when lower(z.talentemplate) in ('gas basis swaps',
                                                    'gas index physicals',
                                                    'gas index swaps') then 'Basis Swap'
                    when lower(z.talentemplate) in ('heatrate physicals',
                                                    'heatrate swaps') then 'Spread Swap'
                    when lower(z.talentemplate) in ('gas fixed financial options',
                                                    'power fixed options',
                                                    'power fixed swaptions') then 'European Option'
                  end DealType,
                  trim(z.cpty)Counterparty, 
                  CASE 
                    WHEN lower(z.talentemplate) IN ('heatrate physicals', 
                                                    'heatrate swaps') 
                      THEN z.heatrate 
                  end HEATRATE, 
                  0 COST,
                  trim(z.Currency) Currency,
                  to_char(z.dmo,'yyyy-mm-dd') StartDate,
                  to_char(last_day(z.dmo),'yyyy-mm-dd') EndDate,
                  case
                    when lower(z.talentemplate) in ('coal physicals') then
                      round((abs(z.total_qty)/mrktc.mrktc_lineloss)/(last_day(z.dmo) - z.dmo),6)
                    else abs(z.total_qty)
                  end Volume,
                  case
                    when lower(z.side1_commodity) in ('coal','gas') then 'daily'
                    when lower(z.side1_commodity) in ('power') then 'hourly'
                    else 'total'
                  end DelFreq,
                  case
                    when lower(z.talentemplate) in ('coal physicals')
                      then dealprice * mrktc.mrktc_lineloss
                    when lower(z.talentemplate) in ('gas fixed physicals',
                                                    'gas fixed swaps',
                                                    'gas basis swaps',
                                                    'gas index physicals',
                                                    'gas index swaps',
                                                    'power fixed physicals',
                                                    'power fixed swaps',
                                                    'power index physicals',
                                                    'heatrate physicals',
                                                    'heatrate swaps') then dealprice
                    when lower(z.talentemplate) in ('gas fixed financial options',
                                                    'power fixed swaptions',
                                                    'power fixed options') then strikeprice
                  end StrikePrice,
                  case
                    when lower(z.talentemplate) in ('gas fixed financial options',
                                                    'power fixed swaptions',
                                                    'heatrate physicals',
                                                    'heatrate swaps') then side2_price
                  end Premium,
                  z.put_call xOption,
                  case when lower(z.buy_sell) = 'b' then 'Long' else 'Short' end Position,
                  case
                    when z.priceband = 'ON PEAK'  then
                      (case
                          when lower(trim(z.Region)) = 'montana' then 'west_6x16'
                          else lower(trim(region)) || '_' || '5x16'
                       end)
                      when z.priceband = 'OFF PEAK' and lower(trim(z.Region)) != 'ERCOT'
                          then lower(trim(region)) || '_' || 'Wrap'
                      when z.priceband = 'OFF PEAK' and lower(trim(z.Region)) = 'ERCOT'
                          then 'ercot_7x8'
                      when z.priceband = 'WE PEAK'
                          then 'ercot_2x16'
                      when z.priceband = 'ATC'
                          then 'ATC'
                      end PeakPeriod,
                  z.side1_mkt || '_' || z.side1_comp MarketCurve1,
                  case
                    when lower(z.talentemplate) in ('gas basis swaps',
                                                    'gas index physicals',
                                                    'gas index swaps',
                                                    'heatrate physicals',
                                                    'heatrate swaps',
                                                    'power index physicals')
                                        then z.side2_mkt || '_' || z.side2_comp
                    else ''
                  end MarketCurve2
              from
                ( select *
                  from RISK.RISKNONDECOND
                  where zkey in (
                                select distinct(Substr(trim(c23_systemidentifier), 1,
                                  Instr(trim(c23_systemidentifier), '_') - 1)) as ZKEY
                                from RISK.Z_ASCEND_DEALS_FILE ) ) z
                  left join mrktc
                    on mrktc.mrktc_mkt = z.side1_mkt
                      and mrktc.mrktc_comp = z.side1_comp
                      and mrktc.mrktc_aohm > sysdate
              where to_char(z.asof, 'yyyy-mm-dd') = ':rptDate' 
                and lower(z.risk_tradetype) not in ('plan adj%', 
                                                    'tranmsission', 
                                                    'brokerfee', 
                                                    'management fees') 
                and lower(z.talentemplate) not in ('gas index swaps')"

  qryString    <- gsub(":rptDate", rptDate, qryString)

  #create connection object
  dbConnection <- do.call(DBI::dbConnect, db_ConnParams_Aligne)

  #execute procedure and store results
  results      <- DBI::dbGetQuery(dbConnection, qryString)

  #close connection
  DBI::dbDisconnect(dbConnection)

  return( results )

}
