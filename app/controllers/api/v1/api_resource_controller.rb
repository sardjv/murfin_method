class Api::V1::ApiResourceController < ApplicationController
  include JSONAPI::ActsAsResourceController
  # include SecuredWithToken
end
