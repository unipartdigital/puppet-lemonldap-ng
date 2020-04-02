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

  $flatchanges = [
    "set dict/entry[. = \"applicationList\"]/dict/entry[. = \"1apps\"]/dict/entry[. = \"catname\"]/string \"${company}\"",
    "set dict/entry[. = \"applicationList\"]/dict/entry[. = \"2administration\"]/dict/entry[. = \"manager\"]/dict/entry[. = \"options\"]/dict/entry[. = \"uri\"]/string \"https://manager.${domain}/manager.html\"",
    "set dict/entry[. = \"applicationList\"]/dict/entry[. = \"2administration\"]/dict/entry[. = \"notifications\"]/dict/entry[. = \"options\"]/dict/entry[. = \"uri\"]/string \"https://manager.${domain}/notifications.html\"",
    "set dict/entry[. = \"applicationList\"]/dict/entry[. = \"2administration\"]/dict/entry[. = \"sessions\"]/dict/entry[. = \"options\"]/dict/entry[. = \"uri\"]/string \"https://manager.${domain}/sessions.html\"",
    "set dict/entry[. = \"applicationList\"]/dict/entry[. = \"3documentation\"]/dict/entry[. = \"localdoc\"]/dict/entry[. = \"options\"]/dict/entry[. = \"uri\"]/string \"https://manager.${domain}/doc/\"",
    "set dict/entry[. = \"AuthLDAPFilter\"]/string \"${authldapfilter}\"",
    "set dict/entry[. = \"certificateResetByMailReplyTo\"]/string \"noreply@${maildomain}\"",
    "set dict/entry[. = \"certificateResetByMailSender\"]/string \"noreply@${maildomain}\"",
    "set dict/entry[. = \"certificateResetByMailURL\"]/string \"http://auth.${domain}/certificateReset\"",
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
    "set dict/entry[. = \"mailUrl\"]/string \"https://auth.${domain}/resetpwd\"",
    "set dict/entry[. = \"managerDn\"]/string \"${manager_dn}\"",
    "set dict/entry[. = \"managerPassword\"]/string \"${manager_password}\"",
    "set dict/entry[. = \"portal\"]/string \"https://auth.${domain}\"",
    "set dict/entry[. = \"portalMainLogo\"]/string \"${logo}\"",
    "set dict/entry[. = \"registerUrl\"]/string \"https://auth.${domain}/register\"",
    "set dict/entry[. = \"reloadUrls\"]/dict/entry[. = \"localhost\"] \"localhost\"",
    "set dict/entry[. = \"reloadUrls\"]/dict/entry[. = \"localhost\"]/string \"https://reload.${domain}/reload\"",
    "set dict/entry[. = \"samlServicePrivateKeyEnc\"]/string \"${saml_enc_key}\"",
    "set dict/entry[. = \"samlServicePrivateKeySig\"]/string \"${saml_sig_key}\"",
    "set dict/entry[. = \"samlServicePublicKeyEnc\"]/string \"${saml_enc_key_pub}\"",
    "set dict/entry[. = \"samlServicePublicKeySig\"]/string \"${saml_sig_key_pub}\"",
  ]

  $locationchanges = [
    "set dict/entry[. = \"locationRules\"]/dict/entry[. = \"auth.${domain}\"] \"auth.${domain}\"",
    "set dict/entry[. = \"locationRules\"]/dict/entry[. = \"auth.${domain}\"]/dict/entry[. = \"default\"] \"default\"",
    "set dict/entry[. = \"locationRules\"]/dict/entry[. = \"auth.${domain}\"]/dict/entry[. = \"default\"]/string \"accept\"",
    # "set dict/entry[. = \"locationRules\"]/dict/entry[. = \"auth.${domain}\"]/dict/entry[2] \"(?#checkUser)^/checkuser\"",
    # "set dict/entry[. = \"locationRules\"]/dict/entry[. = \"auth.${domain}\"]/dict/entry[2]/string \"groupMatch($hGroups, 'cn', '${ldap_admin_group}')\"",
    # "set dict/entry[. = \"locationRules\"]/dict/entry[. = \"auth.${domain}\"]/dict/entry[3] \"(?#errors)^/lmerror/\"",
    # "set dict/entry[. = \"locationRules\"]/dict/entry[. = \"auth.${domain}\"]/dict/entry[3]/string \"accept\"",
    "set dict/entry[. = \"locationRules\"]/dict/entry[. = \"manager.${domain}\"] \"manager.${domain}\"",
    "set dict/entry[. = \"locationRules\"]/dict/entry[. = \"manager.${domain}\"]/dict/entry[. = \"default\"] \"default\"",
    "set dict/entry[. = \"locationRules\"]/dict/entry[. = \"manager.${domain}\"]/dict/entry[. = \"default\"]/string \"groupMatch($hGroups, 'cn', '${ldap_admin_group}')\"",
    # "set dict/entry[. = \"locationRules\"]/dict/entry[. = \"manager.${domain}\"]/dict/entry[2] \"(?#Configuration)^/(.*?\\.(fcgi|psgi)/)?(manager\\.html|confs/|$)\"",
    # "set dict/entry[. = \"locationRules\"]/dict/entry[. = \"manager.${domain}\"]/dict/entry[2]/string \"groupMatch($hGroups, 'cn', '${ldap_admin_group}')\"",
    # "set dict/entry[. = \"locationRules\"]/dict/entry[. = \"manager.${domain}\"]/dict/entry[3] \"(?#Notifications)/(.*?\\.(fcgi|psgi)/)?notifications\"",
    # "set dict/entry[. = \"locationRules\"]/dict/entry[. = \"manager.${domain}\"]/dict/entry[3]/string \"groupMatch($hGroups, 'cn', '${ldap_admin_group}')\"",
    # "set dict/entry[. = \"locationRules\"]/dict/entry[. = \"manager.${domain}\"]/dict/entry[4] \"(?#Sessions)/(.*?\\.(fcgi|psgi)/)?sessions\"",
    # "set dict/entry[. = \"locationRules\"]/dict/entry[. = \"manager.${domain}\"]/dict/entry[4]/string \"groupMatch($hGroups, 'cn', '${ldap_admin_group}')\"",
  ]

  augeas { $context:
    incl    => $filename,
    lens    => 'Json.lns',
    changes => $flatchanges + $locationchanges,
    require => File[$filename]
  }
}
