class ServiceBase
  include ActiveSupport::Concern
  extend ActiveModel::Callbacks

  define_model_callbacks :execute, only: %I[before]

  before_execute :before

  class << self
    def execute!(*args, &block)
      new.execute!(*args, &block)
    end
  end

  def execute!(*_args)
    raise NotImplementedError
  end

  private

  def before; end
end