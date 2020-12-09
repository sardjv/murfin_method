class SignoffsController < ApplicationController
  def sign
    @signoff = Signoff.find(params[:id])

    if @signoff.sign
      respond_to do |format|
        format.json do
          render json: {
            button: {
              text: I18n.t('signoffs.revoke'),
              href: revoke_signoff_path(@signoff),
              class: 'btn btn-danger'
            }
          },
          status: :ok
        end
      end
    end
  end

  def revoke
    @signoff = Signoff.find(params[:id])

    if @signoff.revoke
      respond_to do |format|
        format.json do
          render json: {
            button: {
              text: I18n.t('signoffs.sign'),
              href: sign_signoff_path(@signoff),
              class: 'btn btn-success'
            }
          },
          status: :ok
        end
      end
    end
  end
end
