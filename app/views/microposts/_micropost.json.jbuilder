json.extract! micropost, :id, :title, :description, :user_id, :created_at, :updated_at
json.url micropost_url(micropost, format: :json)
