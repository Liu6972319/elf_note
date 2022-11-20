import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class System {
  String system = Platform.operatingSystem.toString();

  static getPath() async {
    return await getApplicationDocumentsDirectory().then((value) => value.path);
    // String dataPath = "";
    // Directory tempDir = await getApplicationDocumentsDirectory();
    // dataPath = tempDir.path;
    //
    // Completer c = new Completer();
    // new Timer(new Duration(seconds: 1), (){
    //   c.complete('done with time out');
    // });
    // print(c.future.toString());
    // return dataPath;
    // Directory tempDir = await getApplicationDocumentsDirectory();
    // return tempDir.path;
    // switch(system){
    //   case 'android': ''; break;
    //   case 'ios': ''; break;
    //   case 'linux': ''; break;
    //   case 'macos': ''; break;
    //   case 'web': ''; break;
    //   case 'windows': ''; break;
    // }
  }
}