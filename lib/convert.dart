import 'dart:async';

var ts;

void initConvert(var ts3){
    ts = ts3;
}


/// Get Client ID by his name.
/// -1 is returned if no matching client is found.
Future<int> getClientByName(String name) async {

    if (ts == null)
        throw('initConvert() must be called before!');

    if (name == null)
        return -1;

    List<Map> reply = await ts.send('clientfind pattern=${ts.encode(name)}');

    if(reply[0]['id'] != 0 && reply[0]['id'] != null)
        return -1;

    return reply[0]['clid'];
}