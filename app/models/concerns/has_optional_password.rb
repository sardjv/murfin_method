# Devise by default requires password, this concern allows to skip this requirement
# Needs to be used for new record only.
# For existing user leaving password and confirmation fields blank in form is enough.

module HasOptionalPassword
  extend ActiveSupport::Concern

  included do
    attr_accessor :skip_password_validation # virtual attribute to skip password validation
  end

  protected

  # overwrite Devise method
  # https://github.com/heartcombo/devise/blob/45b831c4ea5a35914037bd27fe88b76d7b3683a4/lib/devise/models/validatable.rb#L60
  def password_required?
    return false if skip_password_validation
    super
  end
end

# TODO other way may be removing :validatable from User setup