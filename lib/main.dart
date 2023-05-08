import 'package:flutter/material.dart';
import 'package:listadetarefas/pages/todo_list_page.dart';

void main(){
  
  runApp(Myapp());

}

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: TodoListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

