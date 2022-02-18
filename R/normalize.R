#' @export
normalize <- function(RGset, method){
  if (method == "noob") {
    mSetProcessed <- preprocessNoob(RGset)
  } else if  (method == "swan"){
    mSetProcessed <- preprocessSWAN(RGset)
  } else {
    error("Specify noob or swan!")
  } 
  return(mSetProcessed)
}