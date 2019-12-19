# == Class: lemonldap::branding
#
# === Authors
#
# Seth Tunstall <seth.tunstall@unipart.io>
#

# Set these in Hiera, don't change them here
class lemonldap::branding (
  $logo_dir = 'manager/htdocs/static/logos',
  $logo     = 'company_logo.png',
  $logo_url = 'https://cdn.example.com/company_logo.png',
){
  $llng_dir = $::lemonldap::params::llng_dir
  include ::lemonldap::params

  $company_logo =  "${llng_dir}/${logo_dir}/${logo}"


  file { $company_logo:
    ensure => file,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0644',
    source => $logo_url,
  }
}
