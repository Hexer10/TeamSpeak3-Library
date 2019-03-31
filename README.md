# TeamSpeak
Created from templates made available by Stagehand under a BSD-style license.

A library to connect to TeamSpeak3 using Query Protocol.

## Usage

A simple usage example:
```dart
  var ts3 = TeamSpeak3(InternetAddress.loopbackIPv4, 10011, 'serveradmin', 'mypass');
  await ts3.connect();
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/Hexer10/TeamSpeak3-Library/issues

## References
The latest version of the official documentation can be gathered by downloading and running a TeamSpeak3 server,
they will be located inside the `doc/serverquery` directory.

Thanks to yat.qa the un-official [documentation][yat.qa].


[yat.qa]: http://yat.qa/resources