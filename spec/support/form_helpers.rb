module FormHelpers

  # finds error block withing form field for specified label_for value
  def within_invalid_form_field(label_for, &block)
    within(:xpath, ".//div[@class = 'form-group'][label[@label_for='#{label_for}']]/div[@class = 'invalid-feedback']", &block)
  end

end
