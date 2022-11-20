import 'package:flutter/material.dart';

class Login extends StatefulWidget{
  const Login({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}
class LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      child: Image.asset(
        "images/9886d573c878468e940c288f2084f0d7.jpeg",
        fit: BoxFit.cover,
      ),
      constraints: new BoxConstraints.expand(),
    );
    // return Image.asset(
    //     "images/9886d573c878468e940c288f2084f0d7.jpeg",
    //   width: MediaQuery.of(context).size.width,
    //   height: MediaQuery.of(context).size.height,
    //   fit: BoxFit.cover,
    // );
  }

}