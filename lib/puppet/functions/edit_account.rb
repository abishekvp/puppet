# frozen_string_literal: true

require_relative 'logging'
require_relative 'api'

Puppet::Functions.create_function(:edit_account) do
  dispatch :execute do
    param 'String', :server_url
    param 'String', :authtoken
    param 'Optional[String]', :org
    param 'Optional[String]', :certificate
    param 'Integer', :account_id
    param 'String', :account_type
    param 'Optional[String]', :account_title
    param 'Optional[String]', :account_name
    param 'Optional[Boolean]', :personal_account
    param 'Optional[String]', :ipaddress
    param 'Optional[String]', :notes
    param 'Optional[String]', :tags
    param 'Optional[Integer]', :folder_id
    param 'Optional[String]', :account_expiration_date
    param 'Optional[String]', :distinguished_name
    param 'Optional[String]', :account_alias
    param 'Optional[String]', :domain_name
  end

  def execute(server_url, authtoken, org, certificate, account_id, account_type, account_title, account_name, personal_account, ipaddress, notes, tags, folder_id, account_expiration_date, distinguished_name, account_alias, domain_name)
    initialized = API::Init.initialized
    if initialized == false
      API::Init.new(
        server_url: server_url,
        authtoken: authtoken,
        org: org,
        certificate: certificate
      )
    end

    API::Account.edit(
      account_id: account_id,
      account_type: account_type,
      account_title: account_title,
      account_name: account_name,
      personal_account: personal_account,
      ipaddress: ipaddress,
      notes: notes,
      tags: tags,
      folder_id: folder_id,
      account_expiration_date: account_expiration_date,
      distinguished_name: distinguished_name,
      account_alias: account_alias,
      domain_name: domain_name
    )
  rescue StandardError => e
    Puppet.err("Failed to get account: #{e.message}")
    nil
  end
end
