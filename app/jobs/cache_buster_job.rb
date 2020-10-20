class CacheBusterJob < ApplicationJob
  queue_as :default

  def perform(klass:, ids:)
    klass.constantize.where(id: ids).touch_all
  end
end
