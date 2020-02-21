# Build the lmConf-1 config using augeas
class lemonldap::config::json(
  $json = undef, # hieradata here
){
  $context = '/var/lib/lemonldap-ng/conf/test.json'

  augeas { $context:
    lens => 'Json.lns',
    incl => $context,
  }

  #"AuthLDAPFilter": "<%= @authldapfilter %>",
  #            "catname": "<%= @company %>",
  #                    "uri": "https://manager.<%= @domain %>/manager.html"
  #                    "uri": "https://manager.<%= @domain %>/notifications.html"
  #                    "uri": "https://manager.<%= @domain %>/sessions.html"
  #                    "uri": "https://manager.<%= @domain %>/doc/"
  #    "certificateResetByMailReplyTo": "noreply@<%= @maildomain %>",
  #    "certificateResetByMailSender": "noreply@<%= @maildomain %>",
  #    "certificateResetByMailURL": "http://auth.<%= @domain %>/certificateReset",
  #    "cfgDate": <%= @timestamp %>,
  #    "cfgNum": <%= @config_num %>,
  #    "domain": "<%= @domain %>",
  #        "auth.<%= @domain %>": {
  #        "manager.<%= @domain %>": {
  #        "test1.<%= @domain %>": {
  #    "key": "<%= @lemon_ldap_key %>",
  #    "ldapBase": "<%= @ldap_base_dn %>",
  #    "ldapGroupAttributeName": "<%= @ldap_group_attribute %>",
  #    "ldapGroupBase": "<%= @ldap_group_base %>",
  #    "ldapGroupObjectClass": "<%= @ldap_group_objectclass %>",
  #    "ldapPort": <%= @ldap_port %>,
  #    "ldapServer": "<%= @ldap_server %>",
  #        "auth.<%= @domain %>": {
  #       "(?#checkUser)^/checkuser": "groupMatch($hGroups, 'cn', '<%= @ldap_admin_group %>')",
  #        "manager.<%= @domain %>": {
  #            "(?#Notifications)/(.*?\\.(fcgi|psgi)/)?notifications": "groupMatch($hGroups, 'cn', '<%= @ldap_admin_group %>')",
  #            "(?#Sessions)/(.*?\\.(fcgi|psgi)/)?sessions": "groupMatch($hGroups, 'cn', '<%= @ldap_admin_group %>')",
  #            "default": "groupMatch($hGroups, 'cn', '<%= @ldap_admin_group %>')"
  #        "test1.<%= @domain %>": {
  #            "default": "groupMatch($hGroups, 'cn', '<%= @ldap_admin_group %>')"
  #    "mailFrom": "noreply@<%= @maildomain %>",
  #    "mailUrl": "https://auth.<%= @domain %>/resetpwd",
  #    "managerDn": "<%= @manager_dn %>",
  #    "managerPassword": "<%= @manager_password %>",
  #    "portal": "https://auth.<%= @domain %>/",
  #    "portalMainLogo": "<%= @logo %>",
  #        "auth.<%= @domain %>": {
  #     "manager.<%= @domain %>": {
  #        "test1.<%= @domain %>": {
  #    "registerUrl": "https://auth.<%= @domain %>/register",
  #        "localhost": "https://reload.<%= @domain %>/reload"
  #    "samlServicePrivateKeyEnc": "<%= @saml_enc_key %>",
  #    "samlServicePrivateKeySig": "<%= @saml_sig_key %>",
  #    "samlServicePublicKeyEnc": "<%= @saml_enc_key_pub %>",
  #    "samlServicePublicKeySig": "<%= @saml_sig_key_pub %>",
  #        "auth.<%= @domain %>": {
  #        "manager.<%= @domain %>": {
  ##        "test1.<%= @domain %>": {
  }
