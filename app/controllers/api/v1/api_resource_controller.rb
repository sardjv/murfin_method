class Api::V1::ApiResourceController < ApplicationController
  include JSONAPI::ActsAsResourceController
  include SecuredWithToken
  skip_before_action :authenticate_user!
end
