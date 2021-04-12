class SignoffsController < ApplicationController
  include PlanHelper
  include SignoffHelper

  before_action :find_and_authorize_sign_off

  def sign
    return unless @signoff.sign

    respond_to do |format|
      format.json do
        render json: { plan: state_json_response(@signoff.plan), signoff: revoke_json_response(@signoff) },
               status: :ok
      end
    end
  end

  def revoke
    return unless @signoff.revoke

    respond_to do |format|
      format.json do
        render json: { plan: state_json_response(@signoff.plan), signoff: sign_json_response(@signoff) },
               status: :ok
      end
    end
  end

  def find_and_authorize_sign_off
    @signoff = Signoff.find(params[:id])
    authorize @signoff
  end
end
