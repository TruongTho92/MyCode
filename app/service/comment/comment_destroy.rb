class Comment::CommentDestroy < ServiceBase
  def initialize(id)
    @id = id
  end

  def execute!
    comment = Comment.find_by(id: id)
    return [false, 'Not found comment'] unless comment
    return [true, "Delete Success"] if comment.destroy
    [false, "Delete Fail"]
  end

  private
  attr_accessor :id
end