function securden::edit_account(
  Optional[Hash] $params = {}
) {
  $server_url  = $securden::conf::server_url
  $authtoken   = $securden::conf::authtoken
  $org         = $securden::conf::org
  $certificate = $securden::conf::certificate

  $account_id = $params['account_id']
  $account_type = $params['account_type']
  $account_title = $params['account_title'] ? { undef => undef, default => $params['account_title'] }
  $account_name  = $params['account_name'] ? { undef => undef, default => $params['account_name'] }
  $personal_account = $params['personal_account'] ? { undef => undef, default => $params['personal_account'] }
  $ipaddress = $params['ipaddress'] ? { undef => undef, default => $params['ipaddress'] }
  $notes = $params['notes'] ? { undef => undef, default => $params['notes'] }
  $tags = $params['tags'] ? { undef => undef, default => $params['tags'] }
  $folder_id = $params['folder_id'] ? { undef => undef, default => $params['folder_id'] }
  $account_expiration_date = $params['account_expiration_date'] ? { undef => undef, default => $params['account_expiration_date'] }
  $distinguished_name = $params['distinguished_name'] ? { undef => undef, default => $params['distinguished_name'] }
  $account_alias = $params['account_alias'] ? { undef => undef, default => $params['account_alias'] }
  $domain_name = $params['domain_name'] ? { undef => undef, default => $params['domain_name'] }

  $account_data = edit_account(
    $server_url,
    $authtoken,
    $org,
    $certificate,
    $account_id,
    $account_type,
    $account_title,
    $account_name,
    $personal_account,
    $ipaddress,
    $notes,
    $tags,
    $folder_id,
    $account_expiration_date,
    $distinguished_name,
    $account_alias,
    $domain_name
  )
  return $account_data
}
