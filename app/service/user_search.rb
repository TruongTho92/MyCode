class UserSearch < ServiceBase
  def initialize(text, page)
    @text = text
    @page = page
  end

  def execute!
    return User.paginate(page: page) if text.blank?
    User.search(:email, text).paginate(page: page)
  end

  private
  attr_accessor :text, :page
end