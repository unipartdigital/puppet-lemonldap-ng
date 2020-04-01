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
  $lemon_ldap_key         = $lemonldap::config::lemon_ldap_key
  $ldap_base_dn           = $lemonldap::config::ldap_base_dn
  $ldap_group_attribute   = $lemonldap::config::ldap_group_attribute
  $ldap_group_base        = $lemonldap::config::ldap_group_base
  $ldap_group_objectclass = $lemonldap::config::ldap_group_objectclass
  $ldap_port              = $lemonldap::config::ldap_port
  $ldap_server            = $lemonldap::config::ldap_server
  $manager_dn             = $lemonldap::config::manager_dn
  $manager_password       = $lemonldap::config::manager_password
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

  # Start with a templated JSON file but with no config values included,
  # as this is only to ensure that values we don't care about end up
  # in the finished file. We use `replace => no` to ensure that this
  # file doesn't get changed on every pass.

  file { $filename:
    ensure  => 'present',
    content => template("${module_name}${config_dir}/lmConf-augeas.json.erb"),
    mode    => '0644',
    replace => 'no'
  }

  augeas { $context:
    incl    => $filename,
    lens    => 'Json.lns',
    changes => [
      "set dict/entry[. = \"AuthLDAPFilter\"] AuthLDAPFilter",
      "set dict/entry[. = \"certificateResetByMailReplyTo\"] certificateResetByMailReplyTo",
      "set dict/entry[. = \"certificateResetByMailSender\"] certificateResetByMailSender",
      "set dict/entry[. = \"certificateResetByMailURL\"] certificateResetByMailURL",
      "set dict/entry[. = \"cfgDate\"] cfgDate",
      "set dict/entry[. = \"cfgNum\"] cfgNum",
      "set dict/entry[. = \"domain\"] domain",
      "set dict/entry[. = \"key\"] key",
      "set dict/entry[. = \"ldapBase\"] ldapBase",
      "set dict/entry[. = \"ldapGroupAttributeName\"] ldapGroupAttributeName",
      "set dict/entry[. = \"ldapGroupBase\"] ldapGroupBase",
      "set dict/entry[. = \"ldapGroupObjectClass\"] ldapGroupObjectClass",
      "set dict/entry[. = \"ldapPort\"] ldapPort",
      "set dict/entry[. = \"ldapServer\"] ldapServer",
      "set dict/entry[. = \"mailFrom\"] mailFrom",
      "set dict/entry[. = \"mailUrl\"] mailUrl",
      "set dict/entry[. = \"managerDn\"] managerDn",
      "set dict/entry[. = \"managerPassword\"] managerPassword",
      "set dict/entry[. = \"portal\"] portal",
      "set dict/entry[. = \"portalMainLogo\"] portalMainLogo",
      "set dict/entry[. = \"registerUrl\"] registerUrl",
      "set dict/entry[. = \"samlServicePrivateKeyEnc\"] samlServicePrivateKeyEnc",
      "set dict/entry[. = \"samlServicePrivateKeySig\"] samlServicePrivateKeySig",
      "set dict/entry[. = \"samlServicePublicKeyEnc\"] samlServicePublicKeyEnc",
      "set dict/entry[. = \"samlServicePublicKeySig\"] samlServicePublicKeySig",
      "set dict/entry[. = \"AuthLDAPFilter\"]/string ${authldapfilter}",
      "set dict/entry[. = \"certificateResetByMailReplyTo\"]/string noreply@${maildomain}",
      "set dict/entry[. = \"certificateResetByMailSender\"]/string noreply@${maildomain}",
      "set dict/entry[. = \"certificateResetByMailURL\"]/string http://auth.${domain}/certificateReset",
      "set dict/entry[. = \"cfgDate\"]/number ${timestamp}",
      "set dict/entry[. = \"cfgNum\"]/number ${config_num}",
      "set dict/entry[. = \"domain\"]/string ${domain}",
      "set dict/entry[. = \"key\"]/string ${lemon_ldap_key}",
      "set dict/entry[. = \"ldapBase\"]/string ${ldap_base_dn}",
      "set dict/entry[. = \"ldapGroupAttributeName\"]/string ${ldap_group_attribute}",
      "set dict/entry[. = \"ldapGroupBase\"]/string ${ldap_group_base}",
      "set dict/entry[. = \"ldapGroupObjectClass\"]/string ${ldap_group_objectclass}",
      "set dict/entry[. = \"ldapPort\"]/number ${ldap_port}",
      "set dict/entry[. = \"ldapServer\"]/string ${ldap_server}",
      "set dict/entry[. = \"mailFrom\"]/string noreply@${maildomain}",
      "set dict/entry[. = \"mailUrl\"]/string https://auth.${domain}/resetpwd",
      "set dict/entry[. = \"managerDn\"]/string ${manager_dn}",
      "set dict/entry[. = \"managerPassword\"]/string ${manager_password}",
      "set dict/entry[. = \"portal\"]/string https://auth.${domain}",
      "set dict/entry[. = \"portalMainLogo\"]/string ${logo}",
      "set dict/entry[. = \"registerUrl\"]/string https://auth.${domain}/register",
      "set dict/entry[. = \"samlServicePrivateKeyEnc\"]/string ${saml_enc_key}",
      "set dict/entry[. = \"samlServicePrivateKeySig\"]/string ${saml_sig_key}",
      "set dict/entry[. = \"samlServicePublicKeyEnc\"]/string ${saml_enc_key_pub}",
      "set dict/entry[. = \"samlServicePublicKeySig\"]/string ${saml_sig_key_pub}",
    ],
    require => File[$filename]
  }
}
