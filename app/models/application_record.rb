class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  class << self
    def search(attributes, text)
      if attributes.is_a?(Array)
        query = attributes.map { |attr| "MATCH (#{attr}) AGAINST ('#{text}')" }.join('OR')
        where(query)
      else
        where("MATCH (#{attributes}) AGAINST ('#{text}')")
      end
    end
  end
end
