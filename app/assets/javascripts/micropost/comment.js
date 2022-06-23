function Comment(options){
  var module = this;
  var defaults = {
    container: $('#list_items'),
    template: {
      list_item : $('#user-list-item-template'),
      comment : $('#list-comment-template'),
    },
    api: {
      comment: '/api/v1/comment',
    },
    data: {
      api_token: Cookies.get('api_token'),
    },
  };
  module.settings = $.extend({}, defaults, options);

  module.addComment = function(){
    $(".comment").click(function(){
      let id = $(this).attr("id");
      let input_comment = `#input_comment-${id}`;
      $(`#input_comment-${id}`).toggle();
    });
  };

  module.viewMore = function(){
    $(".btn-showcmt").click(function(){
      el = $(this).closest('li').find('.list-comment');
      el.css("display") === 'none' ? el.show() : el.hide();
    });
  };

  module.eventEnterComment = function(){
    $('.in-comment').keypress(function (e) {
      if (event.keyCode === 13) {
        el = $(this)
        text = $(el).val();
        var parent = $(el).closest('li')
        micropost_id = $(parent).attr('id').split('-')[1];
        $.ajax({
          url: module.settings.api.comment,
          headers: {
            'api_token': module.settings.data.api_token
          },
          type: 'POST',
          data: { text: text, micropost_id: micropost_id },
          dataType: 'json',
          success: function(data) {
            if (data.code == 200) {
              var template_comment = Handlebars.compile(module.settings.template.comment.html());
              $(parent).find('.list-comment').append(template_comment({
                comment: data.data
              }));
              $(el).val("");
              $(parent).find('.list-comment').show();
              $.notify(data.message, 'success');
            } else {
              $.notify(data.message, "error");
            }
          },
          error: function(e) {
            $.notify(e, "error");
          }
        });
      }
    });
  }

  module.init = function(){
    module.addComment();
    module.viewMore();
    module.eventEnterComment();
  };
}

$(document).ready(function(){
  comment = new Comment();
  comment.init();
});

