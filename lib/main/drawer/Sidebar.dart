import 'dart:io';

import 'package:elf_note/common/Global.dart';
import 'package:elf_note/common/System.dart';
import 'package:elf_note/model/Note.dart';
import 'package:elf_note/model/NoteDir.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  MySidebar createState() => MySidebar();
}

class MySidebar extends State<Sidebar> {
  int selectIndex = Global.nodeDirectories!.indexOf(Global.selectedNodeDir!);
  List widgets = [];

  String newDirName = "";

  String errorText = "";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 120,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      image: ExactAssetImage("images/OIP (2).jpeg"),
                      fit: BoxFit.cover)),
              child: Text(
                AppLocalizations.of(context)!.elfNode,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(controller: ScrollController(), children: [
              for (int i = 0; i < Global.nodeDirectories!.length; i++)
                (ListTile(
                    title: Text(Global.nodeDirectories![i].name),
                    selectedColor: Colors.blue,
                    selectedTileColor: Colors.black12,
                    selected: selectIndex == i,
                    onTap: () async {
                      setState(() {
                        // 更新选择的下标
                        selectIndex = i;
                        // 上级页面更新
                        Global.selectedNodeDir = Global.nodeDirectories![i];
                      });
                      // 关闭 返回
                      Navigator.pop(context);
                    },
                    onLongPress: () {
                      // 提示
                      showDialog(
                          context: context,
                          builder: (builder) {
                            return AlertDialog(
                                title: Text("您确定要删除'${Global.nodeDirectories![i].name}'吗?"),
                                content: const Text("该目录下所有文件都将被删除，且该操作不能撤销！"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          Directory dir = Directory(Global.nodeDirectories![i].path);
                                          dir.deleteSync(recursive: true);
                                          Global.nodeDirectories!.removeAt(i);
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: const Text('确定')),
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('取消'))
                                ]);
                          });
                    }))
            ]),
          ),
          Column(
            children: [
              Divider(),
              ListTile(
                title: Text("添加笔记本"),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: const Text("请输入笔记本名称"),
                              content: TextField(
                                  autofocus: true,
                                  onChanged: (value) {
                                    setState(() {
                                      newDirName = value;
                                      errorText = "";
                                      for (var value
                                          in Global.nodeDirectories!) {
                                        if (value.name == newDirName) {
                                          errorText = "'$newDirName' 已经存在";
                                          return;
                                        }
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "名称",
                                      hintText: "您的笔记本名称",
                                      errorText:
                                          errorText != "" ? errorText : null)),
                              actions: [
                                TextButton(
                                  child: const Text("确定"),
                                  onPressed: () {
                                    if (newDirName != "" && errorText == "") {
                                      // 1.创建目录 并将信息存储进 Global
                                      createNodeDir(newDirName);
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                                TextButton(
                                  child: const Text("取消"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          },
                        );
                      }).then((value) => {errorText = "", newDirName = ""});
                },
              )
            ],
          )
        ],
      ),
    );
  }

  createNodeDir(String name) async {
    var path = await System.getPath();
    Directory directory = Directory(path + "/elfNode/" + name);
    await directory.create();
    setState(() {
      // 2.将信息存储进 Global
      NodeDir nodeDir = NodeDir(path: path, name: name, notes: <Note>[]);
      Global.nodeDirectories!.add(nodeDir);
    });
  }
}
