class UsersSerializer < ActiveModel::Serializer
  attributes :id, :avatar, :email, :api_token

  def avatar
    gravatar_id = Digest::MD5.hexdigest(object.email.downcase)
    size = scope && scope[:size] ? scope[:size] : 80
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  end

  def api_token
    object.api_token
  end
end