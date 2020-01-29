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
  $llng_dir         = '/usr/share/lemonldap-ng'
){

  $llng_config     = 'lmConf-1.json' # TODO: replace this with something that 
  # finds the newest file in the directory so that puppet can manage edited
  # config. Also probably need to construct this from fragments so that we
  # can declare the config nicely in Hiera (or collected resources...)

  include ::lemonldap::params

  $company_logo =  "${llng_dir}/${logo_dir}/${logo}"


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
    content => template("${module_name}${config_dir}/${llng_config}.erb"),
  }
}
