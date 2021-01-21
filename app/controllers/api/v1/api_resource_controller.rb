class Api::V1::ApiResourceController < ApplicationController
  skip_before_action :authenticate_user!
  protect_from_forgery with: :null_session

  include JSONAPI::ActsAsResourceController
  include SecuredWithToken
end
