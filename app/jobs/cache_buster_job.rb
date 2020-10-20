class CacheBusterJob < ApplicationJob
  queue_as :default

  def perform(klass:, ids:)
    klass.constantize.find(ids).touch_all
  end
end
