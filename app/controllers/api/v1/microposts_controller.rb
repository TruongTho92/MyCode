class Api::V1::MicropostsController < Api::V1::BaseController
  def index
    microposts = Micropost.all.includes(:user, :comments)
    render json: success_message('Successfully',
      ActiveModelSerializers::SerializableResource.new(microposts,
                                                       each_serializer: MicroPostSerializer))
  end

  def comment
    comment = current_user.comments.build(comment_params)
    if comment.save
      render json: success_message('Successfully',
        ActiveModelSerializers::SerializableResource.new(comment,
                                                         each_serializer: CommentSerializer))
    else
      render json: error_message(comment.errors.full_messages.first)
    end
  end

  private

  def comment_params
    { content: params[:content], micropost_id: params[:micropost_id] }
  end
end