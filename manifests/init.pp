# Class to install ngrok
#
class ngrok(
  $port      = $ngrok::params::port,
  $url       = $ngrok::params::url,
  $file      = $ngrok::params::file,
  $directory = $ngrok::params::directory,
  $start     = $ngrok::params::start,
  $subdomain = $ngrok::params::subdomain,
  $httpauth  = $ngrok::params::httpauth,
  $proto     = $ngrok::params::proto,
  $client    = $ngrok::params::client,
  $host      = $ngrok::params::host,
  $log       = $ngrok::params::log,
  $config    = $ngrok::params::config,
) inherits ngrok::params {

  if defined(File[$directory]) == false {
    file { $directory:
      ensure  => directory,
    }
  }

  if defined(Package['unzip']) == false {
    package { 'unzip':
      ensure => installed,
    }
  }

  exec { 'download-ngrok':
    command => "/usr/bin/wget ${url}/${file}",
    cwd     => $directory,
    creates => "${directory}/${file}",
    require => [ Package['unzip'], File[$directory] ]
  }
  -> exec { 'extract-ngrok':
    command => "/usr/bin/unzip ${file}",
    cwd     => $directory,
    creates => "${directory}/ngrok",
    require => [ Package['unzip'], Exec['download-ngrok'] ],
  }

  case $::osfamily {
    'Debian': {
        file { 'install-ngrok':
          ensure  => link,
          path    => '/usr/local/bin/ngrok',
          target  => "${directory}/ngrok",
          require => Exec['extract-ngrok'],
        }
    }
    default: {
      fail("Unsupported operating system: ${::operatingsystem}.")
    }
  }

  if $subdomain {
    $param_sub = "-subdomain=${subdomain}"
  } else {
    $param_sub = ''
  }

  if $httpauth {
    $param_auth = "-httpauth=${httpauth}"
  } else {
    $param_auth = ''
  }

  if $proto {
    $param_proto = "-proto=${proto}"
  } else {
    $param_proto = ''
  }

  if $::hostname {
    $param_hostname = "-hostname=${::hostname}"
  } else {
    $param_hostname = ''
  }

  if $log {
    $param_log = "-log=${log}"
  } else {
    $param_log = '-log=stdout'
  }

  if $config {
    $param_config = "-config=${config}"
  } else {
    $param_config = ''
  }

  if $start {
    if $client {
      exec { 'ngrok-client-start':
        command  => "/usr/local/bin/ngrok ${param_config} ${param_log} start ${client}",
        require  => File['install-ngrok'],
      }
    } else {
      exec { 'ngrok-start':
        command  => "/usr/local/bin/ngrok ${param_sub} ${param_auth} ${param_proto} ${param_hostname} ${param_log} ${port}",
        require  => File['install-ngrok'],
      }
    }
  }

}
