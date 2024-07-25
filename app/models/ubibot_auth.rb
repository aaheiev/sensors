class UbibotAuth < ApplicationRecord
  encrypts :token
  @ubibot_auth_url = "#{Rails.application.config.ubibot_auth_url}?account_key=#{ ENV["UBIBOT_ACCOUNT_KEY"]}"

  def self.get_token
    Rails.logger.info "Requested UbiBot auth_token"
    last_auth = UbibotAuth.where("expired_at > :current_timestamp",{current_timestamp: DateTime.now}).order(expired_at: :desc).first
    if last_auth
      Rails.logger.info "Return existing UbiBot auth_token"
      return last_auth.token
    else
      Rails.logger.info "Requesting new UbiBot auth_token"
      response = Faraday.get(@ubibot_auth_url)
      if response.status == 200
        auth = UbibotAuth.create(
          expired_at:  JSON.parse(response.body)["expire_time"],
          server_time: JSON.parse(response.body)["server_time"],
          token:       JSON.parse(response.body)["token_id"]
        )
        Rails.logger.info "Save new UbiBot auth_token"
        return auth.token
      end
    end
  end
  def self.cleanup
    UbibotAuth.where('expired_at < ?', DateTime.now - 2.hour).delete_all
  end
end
