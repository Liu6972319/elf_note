import 'dart:io';

import 'package:elf_note/common/Global.dart';
import 'package:elf_note/main/drawer/Sidebar.dart';
import 'package:elf_note/model/Note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// 主页
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _home();
  }
}

class _home extends State<Home> {

  String? filename;

  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Sidebar(),
        onDrawerChanged: (isOpen) {
          // 设置左侧 关闭时更新状态
          if (!isOpen) {
            // 关闭时刷新状态
            setState(() {});
          }
        },
        appBar: AppBar(
            // title: Text(AppLocalizations.of(context)!.elfNode),
            title: Text(Global.selectedNodeDir!.name != ""
                ? Global.selectedNodeDir!.name
                : AppLocalizations.of(context)!.elfNode),
            actions: [
              PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: Row(children: const <Widget>[
                        Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                            child: Icon(Icons.add, color: Colors.black)),
                        Text('添加笔记')
                      ]),
                      value: "newNode",
                      onTap: () {
                        Future.delayed(
                          const Duration(),
                              () => showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text("请输入笔记名称"),
                                      content: TextField(
                                          autofocus: true,
                                          onChanged: (value) {
                                            // 更新弹出框提示
                                            setState(() {
                                              filename = value;
                                              for (var element in Global.selectedNodeDir!.notes!) {
                                                if (element.name == value) {
                                                  errorText = "'$value'已经存在";
                                                  return;
                                                } else {
                                                  errorText = null;
                                                }
                                              }
                                            });
                                          },
                                          decoration:  InputDecoration(
                                              labelText: "名称", hintText: "您的笔记名称", errorText: errorText)),
                                      actions: [
                                        TextButton(
                                          child: const Text("确定"),
                                          onPressed: () {
                                            if (errorText == null) {
                                              // 创建文件
                                              bool canCreated = true;
                                              for (Note n in Global.selectedNodeDir!.notes!) {
                                                if (n.name == filename!) {
                                                  canCreated = false;
                                                  return;
                                                }
                                              }
                                              if (canCreated) {
                                                String file = Global.selectedNodeDir!.path + "/" + filename! + ".md";
                                                File f = File(file);
                                                // 创建文件
                                                f.createSync(recursive: true);
                                                // 添加到Global
                                                Note note =
                                                Note(name: filename!, path: f.path, fileName: filename! + ".md");
                                                Global.selectedNodeDir!.notes!.add(note);
                                                Global.selectedNodeDir!.selectedNode = note;
                                                // 关闭输入框并进入edit页面
                                                Navigator.popAndPushNamed(context, "edit");
                                              }
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
                              }).then((value) => setState(() {filename = null;errorText=null;})),
                        );
                      },
                    ),
                  ];
                },
                onSelected: (Object object) {},
              )
              // IconButton(
              //   icon: const Icon(Icons.more_vert),
              //   tooltip: '更多',
              //   onPressed: () {
              //     // handle the press
              //     Navigator.push(context, MaterialPageRoute(builder: (builder)=>More()));
              //
              //   },
              // ),
            ]),
        // TODO： 判断是桌面环境还是移动设备环境
        body: ListView.builder(
          itemCount: Global.selectedNodeDir!.notes!.length,
          itemBuilder: (BuildContext context, int position) {
            return ListTile(
                title: Text(Global.selectedNodeDir!.notes![position].name),
                selectedColor: Colors.blue,
                selectedTileColor: Colors.black12,
                selected: Global.selectedNodeDir!.selectedNode ==
                    Global.selectedNodeDir!.notes![position],
                onTap: () {
                  setState(() {
                    // 设置当前选择的 node
                    Global.selectedNodeDir!.selectedNode =
                        Global.selectedNodeDir!.notes![position];
                    // 进入edit
                    Navigator.pushNamed(context, "edit");
                  });
                },
                onLongPress: () {
                  setState(
                    () {
                      // 提示
                      showDialog(
                          context: context,
                          builder: (builder) {
                            return AlertDialog(
                                title: Text(
                                    "您确定要删除'${Global.selectedNodeDir!.notes![position].name}'吗?"),
                                content: const Text("该文件将被删除，且该操作不能撤销！"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          Directory dir = Directory(Global
                                              .selectedNodeDir!
                                              .notes![position]
                                              .path);
                                          dir.deleteSync(recursive: true);
                                          Global.selectedNodeDir!.notes!
                                              .removeAt(position);
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: const Text('确定')),
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('取消'))
                                ]);
                          }).then((value) => {});
                    },
                  );
                });
          },
        ));
  }
}
