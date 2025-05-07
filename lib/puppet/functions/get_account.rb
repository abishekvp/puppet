# frozen_string_literal: true

require_relative 'logging'
require_relative 'api'

Puppet::Functions.create_function(:get_account) do
  dispatch :execute do
    param 'String', :server_url
    param 'String', :authtoken
    param 'Optional[String]', :org
    param 'Optional[String]', :certificate
    param 'Optional[Integer]', :account_id
    param 'Optional[String]', :account_title
    param 'Optional[String]', :account_name
    param 'Optional[String]', :account_type
    param 'Optional[String]', :ticket_id
    param 'Optional[String]', :reason
  end

  def execute(server_url, authtoken, org, certificate, account_id, account_title, account_name, account_type, ticket_id, reason)
    initialized = API::Init.initialized
    if initialized == false
      API::Init.new(
        server_url: server_url,
        authtoken: authtoken,
        org: org,
        certificate: certificate,
      )
    end

    API::Account.get(
      account_id: account_id,
      account_title: account_title,
      account_name: account_name,
      account_type: account_type,
      ticket_id: ticket_id,
      reason: reason,
    )
  rescue StandardError => e
    Puppet.err("Failed to get account: #{e.message}")
    nil
  end
end
