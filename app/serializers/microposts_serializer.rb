class MicropostsSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :content, :image, :user, :comments,

  def image
    return '' unless object.image.attached?
    variant = object.display_image
    rails_representation_url(variant, only_path: true)
  end

  def user
    ActiveModelSerializers::SerializableResource.new(object.user,
                                                     each_serializer: UsersSerializer)
  end

  def comments
    ActiveModelSerializers::SerializableResource.new(object.comments,
                                                     each_serializer: CommentSerializer)
  end
end