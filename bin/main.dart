import 'dart:io';
import 'dart:async';
import '../lib/ts3.dart';

Socket socket;

TeamSpeak3 ts;

void main() async {

    ts = await new TeamSpeak3(
        ip: 'localhost', //Ts3 IP
		username: user, //Query user name
        password: pass, //Query user password
        cid: 2,  //Default channel id
        nickname: 'A fantastic bot' //Bot nickname
    );

    var data = await ts.connect();
	
	//Error occured
    if (data[0]['id'] != 0 && data[0]['id'] != null){
        print(data[0]['msg']);
        exit(1);
    }

    print('Type /disconnect to stop the bot');
    stdin.listen(onData);
	
	//Register private command
    ts.registerCommand('!help', onCommand, CommandType.PRIVATE);
}

void onCommand(var client, var args){
    print('Client: ${client.clid}');
}

void onData(var data){
    var reply = new String.fromCharCodes(data).trim();
    if (reply == '/disconnect'){
        ts.quit();
        exit(0);
    }
}