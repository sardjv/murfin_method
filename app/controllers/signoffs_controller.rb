class SignoffsController < ApplicationController
  def sign
    @signoff = Signoff.find(params[:id])

    if @signoff.sign
      respond_to do |format|
        format.json { render json: nil, status: :ok }
      end
    end
  end

  def revoke
    @signoff = Signoff.find(params[:id])

    if @signoff.revoke
      respond_to do |format|
        format.json { render json: nil, status: :ok }
      end
    end
  end
end
