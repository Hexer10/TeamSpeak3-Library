import 'dart:async';
import 'dart:io';
import 'package:TS3Bot/client.dart';

import '../lib/ts3.dart';
import '../lib/convert.dart' as convert;

TeamSpeak3 ts;

void main() async {


    //Initiliaze our ts3 class
    ts = await new TeamSpeak3(
        ip: 'localhost', //Ts3 IP
		username: 'serveradmin', //Query user name
        password: 'mysecurepassword', //Query user password
        cid: 2,  //Default channel id
        nickname: 'A fantastic bot' //Bot nickname
    );

    //Connect and authenticate to the server
    var data = await ts.connect();
	
	//Error occured while connecting or authenticating
    if (data[0]['id'] != 0 && data[0]['id'] != null){
        print(data[0]['msg']);
        exit(1);
    }

    //Init our converter
    convert.initConvert(ts);

    //Listen for commandline inputs
    print('Type /disconnect to stop the bot');
    stdin.listen(onData);
	
	//Register private command
    ts.registerCommand('!help', onHelpCmd, CommandType.PRIVATE);
    ts.registerCommand('!target', onTargetCmd, CommandType.PRIVATE);

}

//Called when user types !help <arg...>
//The args start from 1 (0 is the command)
void onHelpCmd(var client, var args){
    //By default the client isn't updated if you need more info run:
    //await client.updateInfo();
    client.message('Thanks for asking help!');
}

void onTargetCmd(var client, var args)async {

    if (args.length != 1){
        client.message('Invalid args: !target <Name>');
    }

    int clientid = await convert.getClientByName(args[1]);

    if (clientid == -1){
        client.message('Invalid target');
        return;
    }

    var target = await new Client(ts, clientid);
    await target.updateInfo();

    client.message('Hello ${target.nickname}');
}

void onData(var data){
    var reply = new String.fromCharCodes(data).trim();
    if (reply == '/disconnect'){
        ts.quit();
        exit(0);
    }
}