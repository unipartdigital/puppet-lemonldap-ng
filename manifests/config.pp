# == Class: lemonldap::config
#
# === Authors
#
# Seth Tunstall <seth.tunstall@unipart.io>
#

# Set these in Hiera, don't change them here
class lemonldap::config (
  $logo_dir               = 'portal/htdocs/static',
  $logo                   = 'common/logos/company_logo.png',
  $logo_url               = 'https://cdn.example.com/company_logo.png',
  $config_dir             = '/var/lib/lemonldap-ng/conf',
  $authldapfilter         = '(&(uid=$user)(objectClass=inetOrgPerson))',
  $auth_choice            = 'LDAP',
  $manager_dn             = 'uid=manager,cn=users,cn=accounts,dc=example,dc=com',
  $manager_password       = undef,
  $ldap_server            = 'ldaps://ldap.example.com',
  $ldap_base_dn           = 'cn=users,cn=accounts,dc=example,dc=com',
  $ldap_group_base        = 'cn=groups,cn=accounts,dc=example,dc=com',
  $ldap_group_objectclass = 'groupOfNames',
  $ldap_group_attribute   = 'member',
  $ldap_port              = '636',
  $ldap_user              = 'uid=admin,cn=users,cn=accounts,dc=example,dc=com',
  $ldap_admin_group       = 'ldapadmins',
  $ldap_password          = undef,
  $company                = 'LemonLDAP::NG',
  $llng_dir               = '/usr/share/lemonldap-ng',
  $lemon_ldap_key         = undef,
  $saml_enc_key           = undef,
  $saml_sig_key           = undef,
  $saml_enc_key_pub       = undef,
  $saml_sig_key_pub       = undef,
  $user_control           = '^[\\\\w\\\\.\\\\-@\\\\+]+$',
  $location_rules         = {},
  $allow_register         = true,
  $allow_change_password  = '"$_auth =~ /^(LDAP|DBI)$/"',
  $allow_reset_password   = true,
){

  $domain         = $lemonldap::params::domain
  $reload_domain  = $lemonldap::params::reload_domain
  $reset_domain   = $lemonldap::params::reset_domain
  $manager_domain = $lemonldap::params::manager_domain
  $auth_domain    = $lemonldap::params::auth_domain
  $maildomain     = $lemonldap::params::maildomain
  $timestamp      = Timestamp().strftime('%s')

  $llng_config = 'lmConf-1.json'
  $company_logo =  "${llng_dir}/${logo_dir}/${logo}"


  file { $company_logo:
    ensure  => 'file',
    owner   => 'apache',
    group   => 'apache',
    mode    => '0644',
    source  => $logo_url,
    require => Package['lemonldap-ng']
  }

  file { $config_dir:
    ensure  => 'directory',
    purge   => true,
    owner   => 'apache',
    group   => 'apache',
    mode    => '0750',
    require => Package['lemonldap-ng']
  }

  $filename = "${config_dir}/${llng_config}"

  file { $filename:
    ensure  => 'file',
    owner   => 'apache',
    group   => 'apache',
    mode    => '0644',
    replace => 'no',
    content => file("${module_name}${config_dir}/lmConf-augeas.json"),
    require => [Package['lemonldap-ng'], File[$config_dir]]
  }

  $allow_register_num = $allow_register? {
    true => 1,
    default => 0
  }

  $allow_reset_password_num = $allow_reset_password? {
    true => 1,
    default => 0
  }

  $flatchanges = [
    "set dict/entry[. = \"applicationList\"]/dict/entry[. = \"1apps\"]/dict/entry[. = \"catname\"]/string \"${company}\"",
    "set dict/entry[. = \"applicationList\"]/dict/entry[. = \"2administration\"]/dict/entry[. = \"manager\"]/dict/entry[. = \"options\"]/dict/entry[. = \"uri\"]/string \"https://${manager_domain}.${domain}/manager.html\"",
    "set dict/entry[. = \"applicationList\"]/dict/entry[. = \"2administration\"]/dict/entry[. = \"notifications\"]/dict/entry[. = \"options\"]/dict/entry[. = \"uri\"]/string \"https://${manager_domain}.${domain}/notifications.html\"",
    "set dict/entry[. = \"applicationList\"]/dict/entry[. = \"2administration\"]/dict/entry[. = \"sessions\"]/dict/entry[. = \"options\"]/dict/entry[. = \"uri\"]/string \"https://${manager_domain}.${domain}/sessions.html\"",
    "set dict/entry[. = \"applicationList\"]/dict/entry[. = \"3documentation\"]/dict/entry[. = \"localdoc\"]/dict/entry[. = \"options\"]/dict/entry[. = \"uri\"]/string \"https://${manager_domain}.${domain}/doc/\"",
    "set dict/entry[. = \"authChoiceModules\"]/dict/entry[1] \"${auth_choice}\"",
    "set dict/entry[. = \"AuthLDAPFilter\"]/string \"${authldapfilter}\"",
    "set dict/entry[. = \"certificateResetByMailReplyTo\"]/string \"noreply@${maildomain}\"",
    "set dict/entry[. = \"certificateResetByMailSender\"]/string \"noreply@${maildomain}\"",
    "set dict/entry[. = \"certificateResetByMailURL\"]/string \"http://${auth_domain}.${domain}/certificateReset\"",
    "set dict/entry[. = \"cfgDate\"]/number ${timestamp}",
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
    "set dict/entry[. = \"portalDisplayChangePassword\"]/string \"${allow_change_password}\"",
    "set dict/entry[. = \"portalDisplayRegister\"]/number ${allow_register_num}",
    "set dict/entry[. = \"portalDisplayResetPassword\"]/number ${allow_reset_password_num}",
    "set dict/entry[. = \"portalMainLogo\"]/string \"${logo}\"",
    "set dict/entry[. = \"post\"]/dict/entry[1] \"${auth_domain}.${domain}\"",
    "set dict/entry[. = \"post\"]/dict/entry[2] \"${manager_domain}.${domain}\"",
    "set dict/entry[. = \"registerUrl\"]/string \"https://${auth_domain}.${domain}/register\"",
    "set dict/entry[. = \"reloadUrls\"]/dict/entry[. = \"localhost\"] \"localhost\"",
    "set dict/entry[. = \"reloadUrls\"]/dict/entry[. = \"localhost\"]/string \"https://${reload_domain}.${domain}/reload\"",
    "set dict/entry[. = \"samlServicePrivateKeyEnc\"]/string \"${saml_enc_key}\"",
    "set dict/entry[. = \"samlServicePrivateKeySig\"]/string \"${saml_sig_key}\"",
    "set dict/entry[. = \"samlServicePublicKeyEnc\"]/string \"${saml_enc_key_pub}\"",
    "set dict/entry[. = \"samlServicePublicKeySig\"]/string \"${saml_sig_key_pub}\"",
    "set dict/entry[. = \"userControl\"]/string \"${user_control}\"",
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

  augeas { $filename:
    incl    => $filename,
    lens    => 'Json.lns',
    changes => $flatchanges + $locationchanges,
    notify  => Service['httpd'],
    require => File[$filename]
  }
}
