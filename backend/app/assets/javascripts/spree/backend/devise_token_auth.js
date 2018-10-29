Spree.ready(function() {
  var appendAuthHeaders = function(xhr, settings) {
    for (var key in Spree.accessTokenData) {
      xhr.setRequestHeader(key, Spree.accessTokenData[key]);
    }
  };

  var updateAuthCredentials = function(ev, xhr, settings) {
    $("#progress").hide();

    var newHeaders = {};

    // set flag to ensure that we don't accidentally nuke the headers
    // if the response tokens aren't sent back from the API
    var blankHeaders = true;

    Spree.accessTokenKeys.forEach(function(key) {
      newHeaders[key] = xhr.getResponseHeader(key);

      if(newHeaders[key])
        blankHeaders = false;
    });

    if(blankHeaders) return;

    for(var key in newHeaders) {
      Spree.accessTokenData[key] = newHeaders[key];
    }
  };

  // intercept requests to the API, append auth headers
  $.ajaxSetup({ beforeSend: appendAuthHeaders });

  // update auth creds after each request to the API
  $(document).ajaxComplete(updateAuthCredentials);
});
