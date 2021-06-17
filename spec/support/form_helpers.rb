module FormHelpers
  # finds form error block within form group field by label text or field name
  def within_invalid_form_field(label, &block)
    within :xpath, ".//div[@class = 'form-group'][label[@for='#{label}' or text() = '#{label}']]//div[contains(@class, 'invalid-feedback')]", &block
  end

  # finds form group by label text or field name
  def within_form_field(label, &block)
    within :xpath, ".//div[@class = 'form-group'][label[@for = '#{label}' or text() = '#{label}']]", &block
  end
end
