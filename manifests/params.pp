class ngrok::params {
  case $::osfamily {
    'Debian': {
      $port      = 80,
      $url       = 'https://dl.ngrok.com/linux_386/',
      $file      = 'ngrok.zip',
      $file_type = 'zip',
      $directory = '/usr/src',
      $start     = true,
      $subdomain = '',
      $httpauth  = '',
      $proto     = '',
      $client    = '',
      $host      = '',
      $log       = '',
      $config    = ''
    }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }
}