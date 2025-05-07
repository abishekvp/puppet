# frozen_string_literal: true

require_relative 'logging'
require_relative 'api'

Puppet::Functions.create_function(:add_account) do
  dispatch :execute do
    param 'String', :server_url
    param 'String', :authtoken
    param 'Optional[String]', :org
    param 'Optional[String]', :certificate
    param 'String', :account_title
    param 'String', :account_type
    param 'Optional[String]', :account_name
    param 'Optional[Boolean]', :personal_account
    param 'Optional[String]', :password
    param 'Optional[String]', :ipaddress
    param 'Optional[String]', :notes
    param 'Optional[String]', :tags
    param 'Optional[Integer]', :folder_id
    param 'Optional[String]', :account_expiration_date
    param 'Optional[String]', :distinguished_name
    param 'Optional[String]', :account_alias
    param 'Optional[String]', :domain_name
  end

  def execute(server_url, authtoken, org, certificate, account_title, account_type, account_name, personal_account,
              password, ipaddress, notes, tags, folder_id, account_expiration_date, distinguished_name, account_alias, domain_name)
    initialized = API::Init.initialized
    if initialized == false
      API::Init.new(
        server_url: server_url,
        authtoken: authtoken,
        org: org,
        certificate: certificate
      )
    end

    API::Account.add(
      account_title: account_title,
      account_name: account_name,
      account_type: account_type,
      personal_account: personal_account,
      password: password,
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
    Puppet.err("Failed to add account: #{e.message}")
    nil
  end
end
