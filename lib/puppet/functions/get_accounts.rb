# frozen_string_literal: true

require_relative 'logging'
require_relative 'api'

Puppet::Functions.create_function(:get_accounts) do
  dispatch :execute do
    param 'String', :server_url
    param 'String', :authtoken
    param 'Optional[String]', :org
    param 'Optional[String]', :certificate
    param 'Optional[Array[Integer]]', :account_ids
    param 'Optional[Array[Hash[String, Any]]]', :accounts
  end

  def execute(server_url, authtoken, org, certificate, account_ids, accounts)
    initialized = API::Init.initialized
    if initialized == false
      API::Init.new(
        server_url: server_url,
        authtoken: authtoken,
        org: org,
        certificate: certificate,
      )
    end

    API::Accounts.get(
      account_ids: account_ids,
      accounts: accounts,
    )
  rescue StandardError => e
    Puppet.err("Failed to get account: #{e.message}")
    nil
  end
end
