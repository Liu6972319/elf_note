import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:elf_note/common/Global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:markdown/markdown.dart' as md;

class Edit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _edit();
}

class _edit extends State<Edit> {
  /// 是否修改的状态
  static bool isEdit = false;

  /// 获取文件内容
  static String mdStr = "";

  /// 文本填充
  static TextEditingController controller = TextEditingController();

  /// 初始化
  @override
  void initState() {
    super.initState();
    mdStr = File(Global.selectedNodeDir!.selectedNode!.path).readAsStringSync();
    controller = TextEditingController.fromValue(TextEditingValue(
      text: mdStr,
      selection: TextSelection.fromPosition(TextPosition(
          affinity: TextAffinity.downstream, offset: mdStr.length)),
    ));
  }

  static editMarkDown(String text ,String putStr,bool pack){
    String p = pack?putStr:"";
    int start = min(controller.selection.baseOffset, controller.selection.extentOffset);
    int end = max(controller.selection.baseOffset, controller.selection.extentOffset);

    return text.substring(0,start) + putStr + text.substring(start,end) + p +  text.substring(end,text.length);
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> toolbox = [
      IconButton(onPressed: () {
        setState(() {
          String edit = editMarkDown(controller.text, "**", true);
          controller.text = edit;
          mdStr = edit;
          isEdit = true;
        });
      }, icon: Icon(Icons.format_bold)),
      IconButton(onPressed: () {
        setState(() {
          String edit = editMarkDown(controller.text, "~~", true);
          controller.text = edit;
          mdStr = edit;
          isEdit = true;
        });
      }, icon: Icon(Icons.strikethrough_s)),
      IconButton(onPressed: () {
        setState(() {
          String edit = editMarkDown(controller.text, "*", true);
          controller.text = edit;
          mdStr = edit;
          isEdit = true;
        });
      }, icon: Icon(Icons.format_italic)),
      IconButton(onPressed: () {
        /// 获取指针位置
        int cursor = min(controller.selection.baseOffset, controller.selection.extentOffset);
        /// 找到当前位置之前的\n
        var substring = controller.text.substring(0,cursor);
        var lastIndexOf = substring.lastIndexOf("\n") + 1;
        String edit = controller.text.substring(0,lastIndexOf) + "> " + controller.text.substring(lastIndexOf,controller.text.length);

        setState(() {
          controller.text = edit;
          mdStr = edit;
          isEdit = true;
        });
      }, icon: Icon(Icons.format_quote)),
      IconButton(onPressed: () {
      }, icon: Icon(Icons.sort_by_alpha)),
      IconButton(onPressed: () {

      }, icon: Icon(Icons.text_format))
      ,
      IconButton(onPressed: () {

      }, icon: Icon(Icons.text_rotate_vertical))
      ,
      IconButton(onPressed: () {

      }, icon: Text("H1"))
      ,
      IconButton(onPressed: () {

      }, icon: Text("H2"))
      ,
      IconButton(onPressed: () {

      }, icon: Text("H3"))
      ,
      IconButton(onPressed: () {

      }, icon: Text("H4"))
      ,
      IconButton(onPressed: () {

      }, icon: Text("H5"))
      ,
      IconButton(onPressed: () {

      }, icon: Text("H6"))
      ,
      IconButton(onPressed: () {

      }, icon: Icon(Icons.list))
      ,
      IconButton(onPressed: () {

      }, icon: Icon(Icons.format_list_numbered))
      ,
      IconButton(onPressed: () {

      }, icon: Icon(Icons.minimize))
      ,
      IconButton(onPressed: () {

      }, icon: Icon(Icons.link))
      ,
      IconButton(onPressed: () {

      }, icon: Icon(Icons.anchor))
      ,
      IconButton(onPressed: () {

      }, icon: Icon(Icons.image)),
      IconButton(onPressed: () {

      }, icon: Icon(Icons.code))
      ,
      IconButton(onPressed: () {

      }, icon: Icon(Icons.table_view))
      ,
      IconButton(onPressed: () {

      }, icon: Icon(Icons.access_time))
      ,
      IconButton(onPressed: () {

      }, icon: Icon(Icons.emoji_emotions_outlined))
      ,
      IconButton(onPressed: () {

      }, icon: Icon(Icons.html))
      ,
    ];

    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Tab(icon: Icon(Icons.preview)),
                      Text("预览")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [Tab(icon: Icon(Icons.edit)), Text("修改")],
                  ),
                ],
              ),
              title: Text((isEdit ? "* " : "") +
                  Global.selectedNodeDir!.selectedNode!.name),
            ),
            body: TabBarView(
              children: [
                /// 预览
                Markdown(data: mdStr),

                /// 修改
                TextField(
                  expands: true,
                  maxLines: null,
                  controller: controller,
                  onChanged: (value) {
                    /// TODO: 当前默认修改操作则认为文件有改动  需设置标识
                    /// 后续改成文档记忆功能
                    setState(() {
                      mdStr = value;
                      isEdit = true;
                    });
                  },
                )
              ],
            ),
            floatingActionButton: isEdit
                ? FloatingActionButton(
                    child: Icon(Icons.save),
                    tooltip: "保存",
                    onPressed: () {
                      setState(() {
                        File editFile = File(Global.selectedNodeDir!.selectedNode!.path);
                        editFile.writeAsStringSync(mdStr);
                        isEdit = false;
                      });
                    },
                  )
                : null,
            bottomSheet: Container(
                height: 40,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: toolbox.length,
                    itemBuilder: (BuildContext context, int position) {
                      // return Container(margin:EdgeInsets.all(0) ,child: toolbox[position]);
                      return toolbox[position];
                    })
            )
        )
    );
  }
}
