utils_SendEmail <- function(subject,
                            body,
                            from    = cQuantBatch:::email_from,
                            to      = cQuantBatch:::email_to, 
                            smtp    = cQuantBatch:::email_smtp,
                            send    = cQuantBatch:::email_send)
{
  
    mailR::send.mail(from    = from,
                     to      = to,
                     subject = subject,
                     body    = body,
                     smtp    = smtp,
                     send    = send)
  
  
    return(TRUE)
}  
