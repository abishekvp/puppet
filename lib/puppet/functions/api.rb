# frozen_string_literal: true

require_relative 'logging'
require 'net/http'
require 'json'
require 'openssl'

module API
  # HTTP methods
  POST = 'POST'
  GET = 'GET'
  PUT = 'PUT'
  DELETE = 'DELETE'

  # API constants
  AUTHTOKEN = 'authtoken'
  ORG = 'org'

  # Log levels
  ERROR = 'err'
  INFO = 'info'
  WARN = 'warning'
  DEBUG = 'debug'

  @private
  class Error < StandardError; end

  class << self
    attr_accessor :server_url, :authtoken, :org, :certificate
  end

  class Init
    def initialize(server_url:, authtoken:, org: nil, certificate: nil)
      if server_url.nil? || authtoken.nil? || server_url.strip.empty? || authtoken.strip.empty?
        Logger.log(ERROR, 'Server URL and authtoken are required to initialize Abi')
        return nil
      end
      unless server_url.start_with?('http://', 'https://')
        Logger.log(ERROR, 'Invalid server URL. It must start with http:// or https://')
        return nil
      end
      API.server_url = server_url.strip
      API.authtoken = authtoken.strip
      API.org = org unless org.to_s.strip.empty? || org.nil?
      API.certificate = certificate
      Logger.log(INFO, 'Abi initialized successfully')
    end

    def self.initialized
      if API.server_url.nil? || API.authtoken.nil?
        false
      elsif API.server_url.start_with?('https://', 'http://')
        true
      end
    end
  end

  class Account
    def self.get(account_id: nil, account_title: nil, account_name: nil, account_type: nil, ticket_id: nil, reason: nil)
      unless API.server_url && API.authtoken
        if server_url.nil? || authtoken.nil?
          Logger.log(ERROR,
                     'Abi is not initialized. Server URL and authtoken are required to initialize Abi')
          return nil
        else
          Init.new(server_url: server_url, authtoken: authtoken, org: org, certificate: certificate)
        end
      end
      if account_id.nil? && account_title.nil? && account_name.nil? && account_type.nil?
        Logger.log(ERROR, 'At least one of account_id, account_title, account_name is required')
        return nil
      end
      Logger.log(INFO, 'Fetching account data')
      params = {}
      params['account_id'] = account_id unless account_id.nil?
      params['account_title'] = account_title unless account_title.nil?
      params['account_name'] = account_name unless account_name.nil?
      params['account_type'] = account_type unless account_type.nil?
      params['ticket_id'] = ticket_id unless ticket_id.nil?
      params['reason'] = reason unless reason.nil?
      account = Request.new.raise_request(params, '/secretsmanagement/get_account', GET)
      return nil unless account

      Logger.log(INFO, account['message']) if account['message']
      account
    rescue StandardError => e
      Logger.log(ERROR, "Failed to fetch account data: #{e.message}")
      nil
    end

    def self.add(account_title: nil, account_type: nil, account_name: nil, personal_account: nil, password: nil, ipaddress: nil, notes: nil, tags: nil, folder_id: nil, account_expiration_date: nil, distinguished_name: nil, account_alias: nil, domain_name: nil)
      server = Init.initialized
      return nil if server == false

      if account_type.nil?
        Logger.log(ERROR, 'Required Account type')
        return nil
      elsif account_title.nil?
        Logger.log(ERROR, 'Required Account title')
        return nil
      end
      Logger.log(DEBUG, 'Creating account in abi')
      params = {}
      params['account_title'] = account_title
      params['account_type'] = account_type
      params['account_name'] = account_name unless account_name.nil?
      params['personal_account'] = personal_account unless personal_account.nil?
      params['ipaddress'] = ipaddress unless ipaddress.nil?
      params['notes'] = notes unless notes.nil?
      params['tags'] = tags unless tags.nil?
      params['folder_id'] = folder_id unless folder_id.nil?
      params['password'] = password unless password.nil?
      params['account_expiration_date'] = account_expiration_date unless account_expiration_date.nil?
      params['distinguished_name'] = distinguished_name unless distinguished_name.nil?
      params['account_alias'] = account_alias unless account_alias.nil?
      params['domain_name'] = domain_name unless domain_name.nil?
      account = Request.new.raise_request(params, '/api/add_account', POST)
      return nil unless account

      Logger.log(DEBUG, account['message']) if account['message']
      account
    rescue StandardError => e
      Logger.log(ERROR, "Failed to add account: #{e.message}")
      nil
    end

    def self.edit(account_id:, account_type:, account_title: nil, account_name: nil, personal_account: nil, password: nil, ipaddress: nil, notes: nil, tags: nil, folder_id: nil, account_expiration_date: nil, distinguished_name: nil, account_alias: nil, domain_name: nil)
      server = Init.initialized
      return nil if server == false

      if account_id.nil? || account_type.nil?
        Logger.log(ERROR, 'Required account ID and Account type')
        return nil
      end
      Logger.log(DEBUG, 'Updating account in abi')
      params = {}
      params['account_id'] = account_id
      params['account_type'] = account_type
      params['account_title'] = account_title unless account_title.nil?
      params['account_name'] = account_name unless account_name.nil?
      params['password'] = password unless password.nil?
      params['ipaddress'] = ipaddress unless ipaddress.nil?
      params['personal_account'] = personal_account unless personal_account.nil?
      params['notes'] = notes unless notes.nil?
      params['tags'] = tags unless tags.nil?
      params['folder_id'] = folder_id unless folder_id.nil?
      params['account_expiration_date'] = account_expiration_date unless account_expiration_date.nil?
      params['distinguished_name'] = distinguished_name unless distinguished_name.nil?
      params['account_alias'] = account_alias unless account_alias.nil?
      params['domain_name'] = domain_name unless domain_name.nil?
      account = Request.new.raise_request(params, '/api/edit_account', PUT)
      if account
        Logger.log(DEBUG, account['message']) if account['message']
        account
      else
        Logger.log(ERROR, 'Failed to update account')
        nil
      end
    rescue StandardError => e
      Logger.log(ERROR, "Could not update account: #{e}")
      nil
    end
  end

  class Accounts
    def self.get(account_ids: [], accounts: [])
      Logger.log(DEBUG, 'Fetching accounts from abi')
      server = Init.initialized
      return nil if server == false

      params = {}
      if account_ids
        params['account_ids'] = account_ids
      elsif accounts
        params['accounts'] = accounts
      else
        Logger.log(ERROR, 'Account IDs or accounts data required')
        return nil
      end
      Logger.log(DEBUG, 'Fetching accounts from Abi')
      accounts_data = Request.new.raise_request(params, '/secretsmanagement/get_accounts', POST)
      return nil unless accounts_data

      Logger.log(DEBUG, accounts_data['message']) if accounts_data['message']
      accounts_data
    rescue StandardError => e
      Logger.log(ERROR, "Could not fetch accounts: #{e}")
      nil
    end

    def self.delete(reason:, account_ids: [], delete_permanently: nil)
      Logger.log(DEBUG, 'Deleting accounts from abi')
      server = Init.initialized
      return nil if server == false

      if account_ids.empty? || account_ids.nil?
        Logger.log(ERROR, 'Required account IDs')
        return nil
      end
      Logger.log(DEBUG, 'Deleting accounts from abi')
      params = {}
      params['account_ids'] = account_ids
      params['reason'] = reason unless reason.nil?
      params['delete_permanently'] = delete_permanently unless delete_permanently.nil?
      response = Request.new.raise_request(params, '/api/delete_accounts', DELETE)
      if response
        Logger.log(DEBUG, response['message']) if response['message']
        response
      else
        Logger.log(ERROR, 'Failed to delete accounts')
        nil
      end
    rescue StandardError => e
      Logger.log(ERROR, "Could not delete accounts: #{e}")
      nil
    end
  end

  class Request
    def raise_request(payload, request_path, method)
      Logger.log(DEBUG, 'Raising API request to Abi server.')
      uri = URI(API.server_url + request_path)
      uri.query = URI.encode_www_form(payload) if method == GET && !payload.empty?
      http = set_http(uri)
      case method
      when GET
        request = Net::HTTP::Get.new(uri)
      when POST
        request = Net::HTTP::Post.new(uri)
      when PUT
        request = Net::HTTP::Put.new(uri)
      when DELETE
        request = Net::HTTP::Delete.new(uri)
      end
      request = set_header(request)
      request['Content-Type'] = 'application/json' if method != GET
      request.body = payload.to_json unless payload.nil? || payload.empty?
      response = http.request(request)
      handle_response(response)
    rescue StandardError => e
      Logger.log(ERROR, e.to_s)
      nil
    end

    protected

    def handle_response(response)
      status_code = nil
      if response.code && !response.code.strip.empty?
        status_code = response.code.to_i
      else
        response.status_code && !response.status_code.strip.empty?
        status_code = response.status_code.to_i
      end
      response = JSON.parse(response.body)
      if !status_code.nil? && status_code == 200
        return response
      elsif response['error']
        message = response['error']['message']
      else
        message = response['message']
      end

      Logger.log(ERROR, "#{response['status_code']}: #{message}")
      nil
    rescue StandardError => e
      Logger.log(ERROR, "HTTP request failed: #{e.message}")
      nil
    end

    def set_header(request)
      request[AUTHTOKEN] = API.authtoken
      request[ORG] = API.org if API.org && !API.org.strip.empty?
      request
    end

    def set_http(uri)
      Logger.log(DEBUG, 'Setting up HTTP connection.')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'
      if API.server_url.start_with?('https://')
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        configure_ssl(http, uri)
      end
      http
    rescue StandardError => e
      Logger.log(ERROR, "Failed to set HTTP connection: #{e.message}")
      nil
    end

    def configure_ssl(http, uri)
      if API.server_url.start_with?('https://')
        if API.certificate
          handle_ssl_certificate(http)
        else
          Logger.log(DEBUG, 'No SSL certificate provided. Attempting to fetch from server.')
          fetch_and_set_server_certificate(http, uri)
        end
      end
    rescue StandardError => e
      Logger.log(ERROR, "Failed to configure SSL: #{e.message}")
      nil
    end

    def handle_ssl_certificate(http)
      Logger.log(DEBUG, 'Adding SSL certificate.')
      if API.certificate.start_with?('-----BEGIN CERTIFICATE-----')
        cert_object = OpenSSL::X509::Certificate.new(API.certificate)
        http.cert_store = OpenSSL::X509::Store.new
        http.cert_store.add_cert(cert_object)
      elsif File.exist?(API.certificate)
        http.ca_file = API.certificate
      else
        Logger.log(ERROR, 'Invalid certificate value or file path')
        return nil
      end
      http
    rescue OpenSSL::X509::Certificateerr => e
      Logger.log(ERROR, "Invalid certificate format: #{e.message}")
      nil
    end

    def verify_certificate_domain(cert, uri)
      cn = cert.subject.to_s.match(%r{CN=([^\s/,]+)}i)&.captures&.first
      sans = cert.extensions.select do |ext|
               ext.oid == 'subjectAltName'
             end.flat_map { |ext| ext.value.split(', ').grep(/^DNS:/) }.map do |dns|
        dns.gsub(/^DNS:/,
                 '')
      end
      cert_domains = [cn, *sans].compact
      cert_domains.any? do |domain|
        if domain.start_with?('*.')
          uri.host.end_with?(domain[2..])
        else
          uri.host == domain
        end
      end
    end

    def fetch_and_set_server_certificate(http, uri)
      Logger.log(WARN, "Attempting to fetch SSL certificate from #{uri.host}:#{uri.port}")
      tcp_socket = TCPSocket.new(uri.host, uri.port || 443)
      ssl_context = OpenSSL::SSL::SSLContext.new
      ssl_socket = OpenSSL::SSL::SSLSocket.new(tcp_socket, ssl_context)
      ssl_socket.sync_close = true
      ssl_socket.connect
      peer_cert = ssl_socket.peer_cert
      peer_cert_chain = ssl_socket.peer_cert_chain || [peer_cert]
      unless verify_certificate_domain(peer_cert, uri)
        Logger.log(WARN,
                   "Hostname mismatch: Certificate is for #{peer_cert.subject}, requested #{uri.host}")
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        return
      end
      ssl_socket.close
      tcp_socket.close
      http.cert_store = OpenSSL::X509::Store.new
      http.cert_store.set_default_paths
      peer_cert_chain.each do |cert|
        http.cert_store.add_cert(cert)
      rescue OpenSSL::X509::StoreError => e
        Logger.log(WARN, "Certificate already in store or invalid: #{e.message}")
      end
      verification_result = http.cert_store.verify(peer_cert_chain.first)
      if verification_result
        Logger.log(WARN, 'Successfully verified certificate')
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      else
        Logger.log(WARN, "Certificate verification failed: #{http.cert_store.error_string}")
        if self_signed?(peer_cert_chain.first)
          Logger.log(WARN, 'Server uses self-signed certificate. Adding to trust store.')
          http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        else
          Logger.log(ERROR, 'Untrusted certificate. Disabling SSL verification.')
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
      end
    rescue StandardError => e
      Logger.log(ERROR, 'Failed to establish SSL connection. Disabling SSL verification')
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    ensure
      begin
        ssl_socket&.close
      rescue StandardError
        nil
      end
      begin
        tcp_socket&.close
      rescue StandardError
        nil
      end
    end

    def self_signed?(cert)
      cert.subject.to_s == cert.issuer.to_s
    end
  end
  private_constant :Request
end
