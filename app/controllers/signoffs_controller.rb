class SignoffsController < ApplicationController
  include PlanHelper

  def sign
    @signoff = Signoff.find(params[:id])

    if @signoff.sign
      respond_to do |format|
        format.json do
          render json: {
            plan: {
              state_badge: {
                text: display_state(@signoff.plan),
                class: state_badge_class(@signoff.plan)
              }
            },
            signoff: {
              button: {
                text: I18n.t('signoffs.revoke'),
                href: revoke_signoff_path(@signoff),
                class: 'btn btn-danger'
              }
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
            plan: {
              state_badge: {
                text: display_state(@signoff.plan),
                class: state_badge_class(@signoff.plan)
              }
            },
            signoff: {
              button: {
                text: I18n.t('signoffs.sign'),
                href: sign_signoff_path(@signoff),
                class: 'btn btn-success'
              }
            }
          },
          status: :ok
        end
      end
    end
  end
end
