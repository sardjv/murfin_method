class BaseDecorator < SimpleDelegator
  def decorate(model, decorate_class = nil)
    ApplicationController.helpers.decorate(model, decorate_class)
  end
end
