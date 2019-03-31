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
