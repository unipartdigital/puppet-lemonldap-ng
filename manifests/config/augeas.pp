# Build the lmConf-1 config using augeas
class lemonldap::config::augeas(
  $json       = undef, # hieradata here
  $logo_dir   = 'portal/htdocs/static',
  $logo_url   = 'https://${cdn._domain}example.com/company_logo.png',
  $config_dir = '/var/lib/lemonldap-ng/conf',
  $llng_dir   = '/usr/share/lemonldap-ng',
){
  # Pull this lot in wholesale. Remove later when this becomes
  # lemonldap::config
  $domain                 = $lemonldap::params::domain
  $reload_domain          = $lemonldap::params::reload_domain
  $manager_domain         = $lemonldap::params::manager_domain
  $auth_domain            = $lemonldap::params::auth_domain
  $reset_domain           = $lemonldap::params::reset_domain
  $maildomain             = $lemonldap::params::maildomain
  $company                = $lemonldap::config::company
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
  $location_rules         = $lemonldap::config::location_rules

  $timestamp  = Timestamp().strftime('%s')
  $config_num = 1
  $llng_config = "lmConf-${config_num}.json"
  $company_logo =  "${llng_dir}/${logo_dir}/${logo}"

  $context = 'lmConf.json'
  $filename = '/var/lib/lemonldap-ng/conf/test.json'

  # Start with a templated JSON file but with no important config values included,
  # as this is only to ensure that values we don't care about still end up
  # in the finished file. We use `replace => no` to ensure that this
  # file doesn't get changed on every pass. Every value that we ever care
  # about MUST be changed by Augeas rather than templated here, in order
  # to ensure that changes after file creation are picked up,
  # and to keep the whole thing idempotent.

  file { $filename:
    ensure  => 'present',
    content => file("${module_name}${config_dir}/lmConf-augeas.json"),
    mode    => '0644',
    replace => 'no'
  }

  $flatchanges = [
    "set dict/entry[. = \"applicationList\"]/dict/entry[. = \"1apps\"]/dict/entry[. = \"catname\"]/string \"${company}\"",
    "set dict/entry[. = \"applicationList\"]/dict/entry[. = \"2administration\"]/dict/entry[. = \"manager\"]/dict/entry[. = \"options\"]/dict/entry[. = \"uri\"]/string \"https://${${ma_domain}nager_domain}.${domain}/manager.html\"",
    "set dict/entry[. = \"applicationList\"]/dict/entry[. = \"2administration\"]/dict/entry[. = \"notifications\"]/dict/entry[. = \"options\"]/dict/entry[. = \"uri\"]/string \"https://${${ma_domain}nager_domain}.${domain}/notifications.html\"",
    "set dict/entry[. = \"applicationList\"]/dict/entry[. = \"2administration\"]/dict/entry[. = \"sessions\"]/dict/entry[. = \"options\"]/dict/entry[. = \"uri\"]/string \"https://${${ma_domain}nager_domain}.${domain}/sessions.html\"",
    "set dict/entry[. = \"applicationList\"]/dict/entry[. = \"3documentation\"]/dict/entry[. = \"localdoc\"]/dict/entry[. = \"options\"]/dict/entry[. = \"uri\"]/string \"https://${${ma_domain}nager_domain}.${domain}/doc/\"",
    "set dict/entry[. = \"AuthLDAPFilter\"]/string \"${authldapfilter}\"",
    "set dict/entry[. = \"certificateResetByMailReplyTo\"]/string \"noreply@${maildomain}\"",
    "set dict/entry[. = \"certificateResetByMailSender\"]/string \"noreply@${maildomain}\"",
    "set dict/entry[. = \"certificateResetByMailURL\"]/string \"http://${auth_domain}.${domain}/certificateReset\"",
    "set dict/entry[. = \"cfgDate\"]/number ${timestamp}",
    "set dict/entry[. = \"cfgNum\"]/number ${config_num}",
    "set dict/entry[. = \"domain\"]/string \"${domain}\"",
    "set dict/entry[. = \"key\"]/string \"${lemon_ldap_key}\"",
    "set dict/entry[. = \"ldapBase\"]/string \"${ldap_base_dn}\"",
    "set dict/entry[. = \"ldapGroupAttributeName\"]/string \"${ldap_group_attribute}\"",
    "set dict/entry[. = \"ldapGroupBase\"]/string \"${ldap_group_base}\"",
    "set dict/entry[. = \"ldapGroupObjectClass\"]/string \"${ldap_group_objectclass}\"",
    "set dict/entry[. = \"ldapPort\"]/number ${ldap_port}",
    "set dict/entry[. = \"ldapServer\"]/string \"${ldap_server}\"",
    "set dict/entry[. = \"mailFrom\"]/string \"noreply@${maildomain}\"",
    "set dict/entry[. = \"mailUrl\"]/string \"https://${auth_domain}.${domain}/resetpwd\"",
    "set dict/entry[. = \"managerDn\"]/string \"${manager_dn}\"",
    "set dict/entry[. = \"managerPassword\"]/string \"${manager_password}\"",
    "set dict/entry[. = \"portal\"]/string \"https://${auth_domain}.${domain}/\"",
    "set dict/entry[. = \"portalMainLogo\"]/string \"${logo}\"",
    "set dict/entry[. = \"post\"]/dict/entry[1] \"${auth_domain}.${domain}\"",
    "set dict/entry[. = \"post\"]/dict/entry[2] \"${manager_domain}.${domain}\"",
    "set dict/entry[. = \"registerUrl\"]/string \"https://${auth_domain}.${domain}/register\"",
    "set dict/entry[. = \"reloadUrls\"]/dict/entry[. = \"localhost\"] \"localhost\"",
    "set dict/entry[. = \"reloadUrls\"]/dict/entry[. = \"localhost\"]/string \"https://${${re_domain}load_domain}.${domain}/reload\"",
    "set dict/entry[. = \"samlServicePrivateKeyEnc\"]/string \"${saml_enc_key}\"",
    "set dict/entry[. = \"samlServicePrivateKeySig\"]/string \"${saml_sig_key}\"",
    "set dict/entry[. = \"samlServicePublicKeyEnc\"]/string \"${saml_enc_key_pub}\"",
    "set dict/entry[. = \"samlServicePublicKeySig\"]/string \"${saml_sig_key_pub}\"",
    "set dict/entry[. = \"vhostOptions\"]/dict/entry[1] \"${auth_domain}.${domain}\"",
    "set dict/entry[. = \"vhostOptions\"]/dict/entry[2] \"${manager_domain}.${domain}\"",
  ]

  $locationchanges = $location_rules.map |$k, $v| {
    ["set dict/entry[. = \"locationRules\"]/dict/entry[. = \"${k}\"] \"${k}\""] + $v.map |$loc, $rule| {
      [
        "set dict/entry[. = \"locationRules\"]/dict/entry[. = \"${k}\"]/dict/entry[. = \"${loc}\"] \"${loc}\"",
        "set dict/entry[. = \"locationRules\"]/dict/entry[. = \"${k}\"]/dict/entry[. = \"${loc}\"]/string \"${rule}\""
      ]
    }
  }

  augeas { $context:
    incl    => $filename,
    lens    => 'Json.lns',
    changes => $flatchanges + $locationchanges,
    require => File[$filename]
  }
}
