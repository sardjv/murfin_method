# frozen_string_literal: true

class Numeric
  class << self
    def percentage_rounded(numerator, denominator, precision = 0)
      result = ((numerator.to_f / denominator) * 100)
      return 0 if result.nan? || result.infinite?

      result.round(precision)
    end
  end
end

class Object
  def as_boolean
    ActiveModel::Type::Boolean.new.cast(self)
  end
end
