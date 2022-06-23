function Micropost(options) {
  var module = this;
  var defaults = {
    container: $('#list_items'),
    template: {
      list_item: $('#user-list-item-template'),
    },
    api: {
      micropost: '/api/v1/microposts'
    },
    data: {
      api_token: Cookies.get("api_token")
    },
  };
  module.settings = $.extend({}, defaults, options);

  module.validate = function(){
    $('#micropost_image').bind('change', function(){
      var size_in_megabytes = this.files[0].size / 1024 / 1024;
      if (size_in_megabytes > 5) {
        alert("Maximum file size is 5MB. Please choose a smaller file.");
      }
    });
  };

  module.post = function(){
    $(".btn-post").on('click', function(){
      $.ajax({
        url: module.settings.api.micropost,
        type: 'GET',
        headers: { api_token: module.settings.data.api_token },
        dataType: 'json',
        success: function(res) {
          if(res.code == 200){
            console.log(res.data);
          }else{
            debugger
          }
        },
        error: function() {
        }
      });
    });
  };

  module.init = function(){
    module.post();
    module.validate();
  };
}

$(document).ready(function(){
  micropost = new Micropost();
  micropost.init();
});