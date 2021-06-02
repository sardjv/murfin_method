module HasRecordWarnings
  extend ActiveSupport::Concern

  included do
    has_many :record_warnings, as: :warnable, dependent: :destroy
  end
end
