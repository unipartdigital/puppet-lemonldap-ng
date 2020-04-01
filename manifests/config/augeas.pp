# Build the lmConf-1 config using augeas
class lemonldap::config::augeas(
  $json       = undef, # hieradata here
  $logo_dir   = 'portal/htdocs/static',
  $logo_url   = 'https://cdn.example.com/company_logo.png',
  $config_dir = '/var/lib/lemonldap-ng/conf',
  $llng_dir   = '/usr/share/lemonldap-ng',
){
  # Pull this lot in wholesale. Remove later when this becomes
  # lemonldap::config
  $domain                 = $lemonldap::params::domain
  $maildomain             = $lemonldap::params::maildomain
  $authldapfilter         = $lemonldap::config::authldapfilter
  $timestamp              = $lemonldap::config::timestamp
  $config_num             = $lemonldap::config::config_num
  $lemon_ldap_key         = $lemonldap::config::lemon_ldap_key
  $ldap_base_dn           = $lemonldap::config::ldap_base_dn
  $ldap_group_attribute   = $lemonldap::config::ldap_group_attribute
  $ldap_group_base        = $lemonldap::config::ldap_group_base
  $ldap_group_objectclass = $lemonldap::config::ldap_group_objectclass
  $ldap_port              = $lemonldap::config::ldap_port
  $ldap_server            = $lemonldap::config::ldap_server
  $manager_dn             = $lemonldap::config::manager_dn
  $logo                   = $lemonldap::config::logo
  $saml_enc_key           = $lemonldap::config::saml_enc_key
  $saml_sig_key           = $lemonldap::config::saml_sig_key
  $saml_enc_key_pub       = $lemonldap::config::saml_enc_key_pub
  $saml_sig_key_pub       = $lemonldap::config::saml_sig_key_pub

  $timestamp  = Timestamp().strftime('%s')
  $config_num = 1
  $llng_config = "lmConf-${config_num}.json"
  $company_logo =  "${llng_dir}/${logo_dir}/${logo}"

  $context = 'lmConf.json'
  $filename = '/var/lib/lemonldap-ng/conf/test.json'

  file { $filename:
    ensure  => 'present',
    content => template("${module_name}${config_dir}/lmConf.json.erb"),
    mode    => '0644',
    replace => 'no'
  }

  augeas { $context:
    incl    => $filename,
    lens    => 'Json.lns',
    changes => [
      "set dict/entry[. = \"AuthLDAPFilter\"] AuthLDAPFilter",
      "set dict/entry[. = \"AuthLDAPFilter\"]/string ${authldapfilter}",
      #"set certificateResetByMailReplyTo noreply@${maildomain}",
      #"set certificateResetByMailSender noreply@${maildomain}",
      #"set certificateResetByMailURL http://auth.${domain}/certificateReset",
      #"set cfgDate $timestamp",
      #"set cfgNum $config_num",
      #"set domain $domain",
      #"set key $lemon_ldap_key",
      #"set ldapBase $ldap_base_dn",
      #"set ldapGroupAttributeName $ldap_group_attribute",
      #"set ldapGroupBase $ldap_group_base",
      #"set ldapGroupObjectClass $ldap_group_objectclass",
      #"set ldapPort $ldap_port",
      #"set ldapServer $ldap_server",
      #"set mailFrom noreply@${maildomain}",
      #"set mailUrl https://auth.${domain}/resetpwd",
      #"set managerDn $manager_dn",
      #"set managerPassword $manager_password",
      #"set portal https://auth.${domain}",
      #"set portalMainLogo $logo",
      #"set registerUrl https://auth.${domain}/register",
      #"set samlServicePrivateKeyEnc $saml_enc_key",
      #"set samlServicePrivateKeySig $saml_sig_key",
      #"set samlServicePublicKeyEnc $saml_enc_key_pub",
      #"set samlServicePublicKeySig $saml_sig_key_pub",
    ],
    require => File[$filename]
  }
}
