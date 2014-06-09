//Chrome passes the error object (5th param) which we must use since it now truncates the Msg (1st param).
window.onerror = function (errorMsg, url, lineNumber, columnNumber, errorObject) {
  var errMsg;
  
  //check the errorObject as IE and FF don't pass it through (yet)
  if (errorObject && errorObject !== undefined) {
    errMsg = errorObject.message;
  }
  else {
    errMsg = errorMsg;
  }

  console.error(errMsg);
}
