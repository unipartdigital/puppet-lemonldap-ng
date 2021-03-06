# Puppet LemonLDAP::NG module

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)

## Overview

This is the puppet LemonLDAP::NG module. It can be used to install LemonLDAP::NG on a server.

## Module Description

Installation can be done on RedHat and Debian systems with Apache

Default SSO domain can also be configured.

## Setup

Call lemonldap::server class to install LemonLDAP::NG on a node:

````
  class { 'lemonldap::server':
    domain        => $facts[domain],
    webserver     => 'apache',
    do_soap       => true,
    #do_ssl       => true,
    ssl_ca_path   => $ssl_ca_path,
    ssl_cert_path => $ssl_cert_path,
    ssl_key_path  => $ssl_key_path,
    sessionstore  => 'redis',
  }

````
