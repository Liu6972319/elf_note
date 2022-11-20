import 'package:elf_note/model/Note.dart';

class NodeDir{

  String path;

  String name;

  // 选择的笔记
  Note? selectedNode;

  // 笔记文件
  List<Note>? notes;

  NodeDir({required this.path,required this.name,this.selectedNode,this.notes});
}