function Session(options) {
  var module = this;
  var defaults = {
    template: {},
    api: {
      login: '/api/v1/login',
    },
    data: {}
  };
  module.settings = $.extend({}, defaults, options);
  
  module.login = function(){
    $(".btn-login").on('click', function(event){
      var email = $('#session_email').val();
      var password = $('#session_password').val();
      var remember_me = $('#session_remember_me').is(':checked');
      $.ajax({
        url: module.settings.api.login,
        type: 'POST',
        data: { email: email, password: password, remember_me: remember_me },
        dataType: 'json',
        success: function(res) {
          if(res.code == 200){
            window.location.href = '/';
            var successOptions = {
              clickToHide: true,
              autoHide: false,
              className: "success",
            };
            setTimeout($.notify("Login Successful", successOptions), 10000);
          }else{
            $.notify(res.message, "error");
          }
        },
        error: function() {
        }
      });
    });
  };
  
  module.init = function(){
    module.login();
  };
}

$(document).ready(function(){
  session = new Session;
  session.init();
});