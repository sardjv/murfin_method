class Note < ApplicationRecord
  enum state: { info: 0, action: 1, resolved: 2 }

  validates :state, :content
end
