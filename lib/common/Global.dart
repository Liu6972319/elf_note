import 'package:elf_note/model/Note.dart';
import 'package:elf_note/model/NoteDir.dart';

class Global{
  // 单例
  static Global instance = Global();

  static String applicationName = "妖精笔记";

  // 选择的文件夹
  static NodeDir? selectedNodeDir;

  // 笔记目录
  static List<NodeDir>? nodeDirectories;

  static bool isLogin = true;

}