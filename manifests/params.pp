# Parameters for ngrok
#
class ngrok::params {
  $architecture = $::architecture ? {
    /^(arm)/ => 'arm',
    default => '386',
  }
  case $::osfamily {
    'Debian': {
      $port      = 80
      $url       = "https://dl.ngrok.com/linux_${architecture}"
      $file      = 'ngrok.zip'
      $file_type = 'zip'
      $directory = '/usr/src'
      $start     = false
      $subdomain = ''
      $httpauth  = ''
      $proto     = ''
      $client    = ''
      $host      = ''
      $log       = ''
      $config    = ''
    }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }
}
