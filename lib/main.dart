import 'dart:io';

import 'package:elf_note/common/Global.dart';
import 'package:elf_note/common/System.dart';
import 'package:elf_note/login/login.dart';
import 'package:elf_note/main/edit/Edit.dart';
import 'package:elf_note/main/home.dart';
import 'package:elf_note/model/Note.dart';
import 'package:elf_note/model/NoteDir.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  /// 加载所有笔记
  initNodes();
  runApp(MyApp());
}

/// 扫描笔记并记录
void initNodes() async {
  String path = await System.getPath();
  Directory dir = Directory(path + "/elfNode");
  // 判断目录是否存在
  if (!dir.existsSync()) {
    // 创建
    dir.createSync(recursive: true);
  }

  List<NodeDir> nodeDirs = [];
  // 遍历主目录
  dir.listSync().forEach((element) {
    if (element.statSync().type.toString() == 'directory') {
      List<Note> notes = eachDir(element);
      String name =
          element.path.replaceFirst(element.parent.path.toString() + "/", "");
      NodeDir nodeDir = NodeDir(path: element.path, name: name, notes: notes);
      nodeDirs.add(nodeDir);
    }
  });
  //TODO: 按创建时间排序

  if (nodeDirs.isNotEmpty) {
    Global.nodeDirectories = nodeDirs;
    Global.selectedNodeDir = nodeDirs[0];
  } else {
    Global.nodeDirectories = nodeDirs;
    Global.selectedNodeDir = NodeDir(path: "", name: "", notes: <Note>[]);
  }

  // Global.notes = notes;
  // //设置选择的笔记
  // Global.selectedNode = notes[0];
}

// 扫描文件夹
List<Note> eachDir(dir) {
  List<Note> notes = <Note>[];
  // 遍历文件夹
  dir.listSync().forEach((element) {
    if (element.statSync().type.toString() == "directory") {
      // 遍历当前文件夹
      notes.addAll(eachDir(Directory(element.path)));
    } else {
      // 遍历文件
      notes.addAll(scanFile(element));
    }
  });
  return notes;
}

// 扫描文件
List<Note> scanFile(element) {
  List<Note> notes = [];
  if (element.path.endsWith('.md')) {
    // 记录
    String fileName =
        element.path.replaceFirst(element.parent.path.toString() + "/", "");
    String name = fileName.replaceFirst(".md", "");
    // 封装note
    Note note = Note(name: name, path: element.path, fileName: fileName);
    notes.add(note);
  }
  return notes;
}

class MyApp extends StatelessWidget {
  // 此小部件是您的应用程序的根.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //语言包
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      //语言包
      supportedLocales: const [
        // generic Chinese 'zh'
        Locale.fromSubtags(languageCode: 'zh'),
        // generic simplified Chinese 'zh_Hans'
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
        // generic traditional Chinese 'zh_Hant'
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
        // 'zh_Hans_CN'
        Locale.fromSubtags(
            languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN'),
        // 'zh_Hant_TW'
        Locale.fromSubtags(
            languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW'),
        // 'zh_Hant_HK'
        Locale.fromSubtags(
            languageCode: 'zh', scriptCode: 'Hant', countryCode: 'HK'),
        // English, no country code
        Locale('en', ''),
        Locale('zh', ''),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "edit": (context) => Edit(),
        "/": (context) => Home()
      },
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) {
          String? routeName = settings.name;
          // 如果访问的路由页需要登录，但当前未登录，则直接返回登录页路由，
          // 引导用户登录；其它情况则正常打开路由。
          if(Global.isLogin){
            return Home();
          }else{
            return Login();
          }
        });
      },
      // home: const Home(),
    );
  }
}
