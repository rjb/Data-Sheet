require 'googleauth'

module GoogleSheet
  class Authorizer
    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'

    def initialize(client_id, scope, token_store)
      @user_authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)
    end

    def credentials
      user_id = 'default'
      @user_authorizer.get_credentials(user_id) || generate_credentials(user_id)
    end

    private

    def generate_credentials(user_id)
      url = @user_authorizer.get_authorization_url(base_url: OOB_URI)

      puts 'Open the following URL in your browser and enter the authorization code'
      puts url

      code = gets
      config = {
        user_id: user_id,
        code: code,
        base_url: OOB_URI
      }

      @user_authorizer.get_and_store_credentials_from_code(config)
    end
  end
end
