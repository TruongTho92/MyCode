class Comment::CommentCreate < ServiceBase
  def initialize(content, user_id, micropost_id)
    @content = content
    @user_id = user_id
    @micropost_id = micropost_id
  end

  def execute!
    comment = Comment.new(content: content, user_id: user_id, micropost_id: micropost_id)
    message = "Comment fail" unless comment.save
  end

  private
  attr_accessor :content, :user_id, :micropost_id
end