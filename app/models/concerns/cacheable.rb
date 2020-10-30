module Cacheable
  extend ActiveSupport::Concern

  included do
    after_update :bust_caches
  end

  def bust_caches
    return unless saved_changes_include?(self.class.watch)

    self.class.bust.each do |bustable|
      CacheBusterJob.perform_later(klass: bustable[:klass], ids: send_chain(bustable[:ids]))
    end
  end

  private

  def saved_changes_include?(attrs)
    (saved_changes.keys & attrs).any?
  end

  def send_chain(methods)
    [*methods].inject(self) { |object, method| object.send(method) }
  end

  module ClassMethods
    attr_reader :watch, :bust

    private

    def cacheable(watch:, bust:)
      @watch = watch
      @bust = bust
    end
  end
end
