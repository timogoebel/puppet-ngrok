puppet-ngrok
=============

Puppet module for installing [ngrok](https://ngrok.com/)

Example usage:

    class { 'ngrok': }

Advanced usage:

    class { 'ngrok':
      port      => '80',
      subdomain => 'myapp',
      httpauth  => 'user:password',
    }

Created by: [Patrick Heeney](https://github.com/patrickheeney)

GitHub: https://github.com/protobox/puppet-ngrok