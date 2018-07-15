library TeamSpeak3;

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'client.dart';

enum HookType{
    SERVER,
    CHANNEL,
    TEXTSERVER,
    TEXTCHANNEL,
    TEXTPRIVATE
}

enum CommandType{
    SERVER,
    CHANNEL,
    PRIVATE
}

class TeamSpeak3{

    Socket _socket;
    Client bot;
    Queue<Completer<List<Map>>> _queue = new Queue();

    String _ip;
    String _name;
    String _password;
    String _nickname;

    int _port;
    int _sid;
    int _cid;
    int _i = 0;

    Map<String, Function> serverCmds = new Map();
    Map<String, Function> channelCmds = new Map();
    Map<String, Function> privateCmds = new Map();

    TeamSpeak3({String ip, int port = 10011, String username, String password, int sid = 1, int cid, String nickname}){
        _ip = ip;
        _port = port;
        _name = username;
        _password = password;
        _sid = sid;
        _cid = cid;

        if (nickname != null) {
            _nickname = this.encode(nickname);
        }
    }

    /// Establish a socket connection with the server and authenticates.
    Future<List<Map>> connect() async {
        await Socket.connect(_ip, _port)
            .then((Socket sock) {
            _socket = sock;
            _socket.listen(
                _dataHandler,
                onError: _errorHandler,
                onDone: _doneHandler,
                cancelOnError: false);
        }).catchError((AsyncError e) {
            print("Connection failed: $e");
            exit(1);
        });
        _socket.done;
        return await _auth();
    }

    Future<List<Map>> _auth() async {
        List<Map> reply = await this.send('login $_name $_password');
        if (reply[0]['id'] != 0){
            return reply;
        }
        _keepAlive();

        reply = await this.send('use $_sid');
        if (reply[0]['id'] != 0){
            return reply;
        }
        reply = await this.send('whoami');
        bot = await new Client(this, reply[0]['client_id']);

        await bot.move(_cid);
        if (_nickname != null)
            await bot.setNickname(_nickname);
        await bot.updateInfo();
        this.send('servernotifyregister event=textserver');
        this.send('servernotifyregister event=textchannel');
        this.send('servernotifyregister event=textprivate');

        return reply;
    }

    //Keep connection alive
    void _keepAlive(){
        const time = const Duration(seconds:590);
        new Timer.periodic(time, (Timer t) => this.send('whoami'));
    }

    /// Sends a command to the socket.
    Future<List<Map>> send(String cmd) {
        _socket.writeln(cmd);
        var completer = new Completer<List<Map>>();
        _queue.add(completer);
        return completer.future;
    }

    void registerCommand(String command, Function onCommand, CommandType type) {
        if (type == CommandType.SERVER){
            serverCmds[command] = onCommand;
        } else if (type == CommandType.CHANNEL) {
            channelCmds[command] = onCommand;
        } else if (type == CommandType.PRIVATE) {
            privateCmds[command] = onCommand;
        }
    }

    void _dataHandler(var data) async {
        var reply = new String.fromCharCodes(data).trim();
        _i++;

        if (_i < 2 ) //The first two reply are from the server's messages
            return;

        List<Map> list = new List();
        List<String> values = reply.replaceAll('\n', '').replaceAll('null', 'nullr').split('|');

        for (var i = 0; i < values.length; i++) {

            Map map = new Map();
            List<String> zones = values[i].split(' ');

            for (var x = 0; x < zones.length; x++){
                if (zones[x] == 'error' || zones[x] == 'notifytextmessage'){
                    continue;
                }

                if (!zones[x].contains('=')){
                    zones[x] = zones[x] + '=null';
                }

                List<String> params = zones[x].split('=');
                for (var y = 0; y < params.length; y+=2){
                    //Convert integer params from String to Int

                    String param = '';
                    try {
                        param = params[y + 1];
                    } catch (e){
                        continue;
                    }

                    try{
                        map[params[y]] = int.parse(param);
                    } catch (e){
                        if (param == 'null')
                            map[params[y]] = null;
                        else
                         map[params[y]] = decode(param.replaceAll('nullr', 'null')).trim();
                    }
                }
            }
            list.add(map);
        }

        if (reply.startsWith('notifytextmessage')){
            List<String> args = list[0]['msg'].replaceAll(new RegExp(r' +(?= )'), '').split(' ');
            if (list[0]['targetmode'] == 1){
                var key = args[0];
                if (!privateCmds.containsKey(key))
                    return;
                privateCmds[key](await new Client(this, list[0]['invokerid']).updateInfo(), args);

            } else if (list[0]['targetmode'] == 2){
                var key = args[0];
                if (!channelCmds.containsKey(key))
                    return;
                channelCmds[key](await new Client(this, list[0]['invokerid']).updateInfo(), args);

            } else if (list[0]['targetmode'] == 3){
                var key = args[0];
                if (!serverCmds.containsKey(key))
                    return;
                serverCmds[key](await new Client(this, list[0]['invokerid']).updateInfo(), args);

            }
        }

        if (!_queue.isEmpty)
            _queue.removeFirst().complete(list);

    }

    void _errorHandler(error, StackTrace trace){
        print(error);
    }

    void _doneHandler(){
        print("Connection termiated!");
        _socket.destroy();
    }

    /// Disconnect the ServerQuery Client form the server.
    void quit() async {
        await this.send('quit');
        _socket.destroy();
    }

    /// Decodes a string according to the TeamSpeak3 Documentation
    String decode(String string){
        if (string == null)
            return null;

        return string.replaceAll('\\s', ' ').replaceAll('\/', '/').replaceAll('\\p', '|').replaceAll('\\\\', '\\');
    }

    /// Encodes a string according to the TeamSpeak3 Documentation
    String encode(String string){
        if (string == null)
            return null;

        return string.replaceAll('\\', '\\\\').replaceAll(' ', '\\s').replaceAll('/', '\/').replaceAll('|', '\\p');
    }

}