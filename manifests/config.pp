# == Class: lemonldap::config
#
# === Authors
#
# Seth Tunstall <seth.tunstall@unipart.io>
#

# Set these in Hiera, don't change them here
class lemonldap::config (
  $logo_dir   = 'portal/htdocs/static/common/logos',
  $logo       = 'company_logo.png',
  $logo_url   = 'https://cdn.example.com/company_logo.png',
  $config_dir = '/var/lib/lemonldap-ng/conf',
){
  $llng_dir = $::lemonldap::params::llng_dir
  $llng_config = 'lmConf-1.json' # TODO: replace this with something that 
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
