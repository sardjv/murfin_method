module SignoffHelper
  def plan_json_response(signoff)
    {
      state_badge: {
        text: display_state(signoff.plan),
        class: state_badge_class(signoff.plan)
      }
    }
  end

  def revoke_json_response(_signoff)
    {
      button: {
        text: I18n.t('signoffs.revoke'),
        href: revoke_signoff_path(@signoff),
        class: 'btn btn-danger'
      }
    }
  end

  def sign_json_response(signoff)
    {
      button: {
        text: I18n.t('signoffs.sign'),
        href: sign_signoff_path(signoff),
        class: 'btn btn-success'
      }
    }
  end
end
