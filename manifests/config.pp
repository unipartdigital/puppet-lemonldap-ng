# == Class: lemonldap::config
#
# === Authors
#
# Seth Tunstall <seth.tunstall@unipart.io>
#

# Set these in Hiera, don't change them here
class lemonldap::config (
  $logo_dir         = 'portal/htdocs/static',
  $logo             = 'common/logos/company_logo.png',
  $logo_url         = 'https://cdn.example.com/company_logo.png',
  $config_dir       = '/var/lib/lemonldap-ng/conf',
  $authldapfilter   = '(&(uid=$user)(objectClass=inetOrgPerson))',
  $manager_dn       = 'uid=manager,cn=users,cn=accounts,dc=example,dc=com',
  $manager_password = undef,
  $ldap_server      = 'ldap://ldap.example.com',
  $ldap_base_dn     = 'cn=users,cn=accounts,dc=example,dc=com',
  $ldap_group_base  = 'cn=groups,cn=accounts,dc=example,dc=com',
  $ldap_user        = 'uid=admin,cn=users,cn=accounts,dc=example,dc=com',
  $ldap_password    = undef,
  $company          = 'LemonLDAP::NG',
  $llng_dir         = '/usr/share/lemonldap-ng',
  $lemon_ldap_key   = undef,
  $saml_enc_key     = undef,
  $saml_sig_key     = undef,
  $saml_enc_key_pub = undef,
  $saml_sig_key_pub = undef
){

  $timestamp = Timestamp().strftime('%s')
  $config_num = $facts['lemonldap_current_config'] + 1
  $llng_config = "lmConf-${config_num}.json"
  $company_logo =  "${llng_dir}/${logo_dir}/${logo}"

  include ::lemonldap::params

  file { $company_logo:
    ensure => file,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0644',
    source => $logo_url,
  }

  file { "${config_dir}/${llng_config}":
    ensure  => file,
    owner   => 'apache',
    group   => 'apache',
    mode    => '0644',
    content => template("${module_name}${config_dir}/lmConf.json.erb"),
  }
}
