class SignoffsController < ApplicationController
  include PlanHelper
  include SignoffHelper

  def sign
    @signoff = Signoff.find(params[:id])

    return unless @signoff.sign

    respond_to do |format|
      format.json do
        render json: { plan: plan_json_response(@signoff), signoff: revoke_json_response(@signoff) },
               status: :ok
      end
    end
  end

  def revoke
    @signoff = Signoff.find(params[:id])

    return unless @signoff.revoke

    respond_to do |format|
      format.json do
        render json: { plan: plan_json_response(@signoff), signoff: sign_json_response(@signoff) },
               status: :ok
      end
    end
  end
end
