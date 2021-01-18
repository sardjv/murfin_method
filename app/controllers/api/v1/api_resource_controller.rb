class Api::V1::ApiResourceController < ApplicationController
  skip_before_action :authenticate_user!

  include JSONAPI::ActsAsResourceController
  include SecuredWithToken
end
