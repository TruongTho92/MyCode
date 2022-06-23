class MicropostSearch < ServiceBase
  def initialize(text, page)
    @text = text
    @page = page
  end

  def execute!
    return Micropost.newest.paginate(page: page) if text.blank?
    Micropost.search(:content, text).paginate(page: page)
  end

  private
  attr_accessor :text, :page
end