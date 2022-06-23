class CommentsSerializer < ActiveModel::Serializer
  attributes :id, :content, :avatar

  def avatar
    gravatar_id = Digest::MD5::hexdigest(object.user.email.downcase)
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=30"
  end
end