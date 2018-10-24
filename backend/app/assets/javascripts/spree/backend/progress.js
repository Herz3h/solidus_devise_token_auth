Spree.ready(function() {
  $(document).ajaxStart(function() {
    $("#progress").show();
  });

  // overridden in devise_token_auth.js
  // $(document).ajaxStop(function() {
  //   $("#progress").hide();
  // });
});
