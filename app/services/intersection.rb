class Intersection
  def self.call(a_start:, a_end:, b_start:, b_end:)
    proportion(
      a_start: a_start,
      a_end: a_end,
      b_start: b_start,
      b_end: b_end
    ) || 0
  end

  def self.proportion(a_start:, a_end:, b_start:, b_end:)
    if intersects_inside?(a_start: a_start, a_end: a_end, b_start: b_start, b_end: b_end)
      (b_end - b_start) / (a_end - a_start)
    elsif intersects_outside?(a_start: a_start, a_end: a_end, b_start: b_start, b_end: b_end)
      1
    elsif intersects_from_start?(a_start: a_start, a_end: a_end, b_end: b_end)
      (b_end - a_start) / (a_end - a_start)
    elsif intersects_to_end?(a_start: a_start, a_end: a_end, b_start: b_start)
      (a_end - b_start) / (a_end - a_start)
    end
  end

  def self.intersects_inside?(a_start:, a_end:, b_start:, b_end:)
    (b_start >= a_start) && (b_end <= a_end)
  end

  def self.intersects_outside?(a_start:, a_end:, b_start:, b_end:)
    (b_start < a_start) && (b_end > a_end)
  end

  def self.intersects_from_start?(a_start:, a_end:, b_end:)
    (b_end >= a_start) && (b_end <= a_end)
  end

  def self.intersects_to_end?(a_start:, a_end:, b_start:)
    (b_start >= a_start) && (b_start <= a_end)
  end
end
