module FormHelpers
  # finds form error block within form group field by specified label_for value
  def within_invalid_form_field(label_for, &block)
    within(:xpath, ".//div[@class = 'form-group'][label[@for='#{label_for}']]/div[@class = 'invalid-feedback']", &block)
  end
end
