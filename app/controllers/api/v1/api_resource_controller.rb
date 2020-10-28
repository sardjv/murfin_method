module Api::V1
  class ApiResourceController < ApplicationController
    include JSONAPI::ActsAsResourceController
    include SecuredWithToken
    skip_before_action :authenticate_user!
  end
end
