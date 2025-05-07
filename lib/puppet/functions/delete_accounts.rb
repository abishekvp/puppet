# frozen_string_literal: true

require_relative 'logging'
require_relative 'api'

Puppet::Functions.create_function(:delete_accounts) do
  dispatch :execute do
    param 'String', :server_url
    param 'String', :authtoken
    param 'Optional[String]', :org
    param 'Optional[String]', :certificate
    param 'Optional[Array[Integer]]', :account_ids
    param 'Optional[String]', :reason
    param 'Optional[Boolean]', :delete_permanently
  end

  def execute(server_url, authtoken, org, certificate, account_ids, reason, delete_permanently)
    initialized = API::Init.initialized
    if initialized == false
      API::Init.new(
        server_url: server_url,
        authtoken: authtoken,
        org: org,
        certificate: certificate
      )
    end

    API::Accounts.delete(
      account_ids: account_ids,
      reason: reason,
      delete_permanently: delete_permanently
    )
  rescue StandardError => e
    Puppet.err("Failed to delete account: #{e.message}")
    nil
  end
end
