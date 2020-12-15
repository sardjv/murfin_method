class SignoffsController < ApplicationController
  include PlanHelper
  include SignoffHelper

  def sign
    @signoff = Signoff.find(params[:id])
    authorize @signoff

    return unless @signoff.sign

    respond_to do |format|
      format.json do
        render json: { plan: state_json_response(@signoff.plan), signoff: revoke_json_response(@signoff) },
               status: :ok
      end
    end
  end

  def revoke
    @signoff = Signoff.find(params[:id])
    authorize @signoff

    return unless @signoff.revoke

    respond_to do |format|
      format.json do
        render json: { plan: state_json_response(@signoff.plan), signoff: sign_json_response(@signoff) },
               status: :ok
      end
    end
  end
end
