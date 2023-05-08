import 'package:listadetarefas/models/todo.dart';
import 'package:flutter/material.dart';
import 'package:listadetarefas/repositories/todo_repository.dart';
import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todocontroller = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];

  Todo? deletedTodo;
  int? deletedTodoPos;
  String? errorText;

  @override
  void initState(){

    super.initState();

    todoRepository.getTodoList().then((value){

      setState((){

        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // serve para as margens conteplarem apenas text filde e o botão, ao invés de toda tela
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todocontroller,
                        // controller: emailcontroller,
                        decoration: InputDecoration(
                          labelText: 'Adicione uma tarefa',
                          labelStyle: TextStyle(fontSize: 22),
                          hintText: 'Terminar o projeto em Flutter',
                          border: OutlineInputBorder(),
                          //borda em todocontorno
                          //border: ImputBorder.none, deixa sem borda nenhuma
                          errorText: errorText,
                          //prefixText: 'R\$' serve para colocarmos um texto fixo que será exibido antes do texto variável , nesse exemplo
                          //usamos o símbolo de reais , para demonstrar como seria se lidássemos com moedas

                          //suffixText: 'cm' serve para colocarmos um texto fixo que será exibido depois do txto variável, como nesse
                          // exemplo que utilizamos unidades de medida
                        ),
                        //obscureText: true,serve para ocultar os carateres como em um password area, vem por padrão com o *
                        //obscuringCharacter: 'x',serve para escolhr o símbolo do obscuring que ficará aparecendo ao invés do *

                        //keyboardType: TextInputType.number, serve para que seja acionado o teclado número, podemos imaginar que o app
                        // peça um documento como CPF para validação do cadastro, faz mais sentido , além de trazer praticidade, acionar o
                        // teclado numérico ao invés do completo

                        //keyboardType: TextInputType.emailAddress, mesmo príncipio que o acima, apenas com a diferença de que esse teclado
                        // virá com o '@' e o '.' de forma mais acessível para deixar mais prático e intuitivo ao usuário

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ), //serve para personalizar o estilo do texto, como fonte, cor,peso e estilo
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        String text = todocontroller.text;
                        if(text.isEmpty){
                          setState((){errorText = "A tarefa não pode estar vazia!!!";});
                          return;
                        };
                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            dateTime: DateTime.now(),
                          );

                          todos.add(newTodo);
                          errorText = null;
                        });
                        todocontroller.clear();
                        todoRepository.saveTodoList(todos);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff00d7f3),
                        // fixedSize: Size(200, 100) serve para colocar um tamanho fixo no botão
                        //padding: const EdgeInsets.all(32),serve para dizer qual o tamanho do espaçamento queremos entre texto e bordas do ícone do botão
                        padding: EdgeInsets.all(15),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 30,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,
                          checkbox: checkbox,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Você possui ${todos.length} tarefas pendentes',
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: showDeleteTodosConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff00d7f3),
                        padding: EdgeInsets.all(14),
                      ),
                      child: Text('Limpar tudo'),
                    )
                  ],
                ),
              ],
            ),
          ),
          /*ElevatedButton(
                      onPressed: (login),
                      child: Text('Entrar')),*/
        ),
      ),
    );
  }
  void checkbox (Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Parabéns!!! Você concluiu a tarefa ${todo.title} com sucesso!',
          style: TextStyle(color: Color(0xff060708), fontSize: 18),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: const Color((0xff00d7f3)),
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
            todoRepository.saveTodoList(todos);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }


  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${todo.title} foi removida com sucesso!',
          style: TextStyle(color: Color(0xff060708), fontSize: 18),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: const Color((0xff00d7f3)),
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
            todoRepository.saveTodoList(todos);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showDeleteTodosConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar Tudo?'),
        content: Text('Você tem certeza que deseja apagar todas as tarefas?'),
        actions: [
          TextButton(
              onPressed: (){

                Navigator.of(context).pop();

              },
              style: TextButton.styleFrom(primary: Color(0xff00d7f3)),
              child: Text('Cancelar')),
          
          TextButton(
              onPressed: (){

                Navigator.of(context).pop();
                deletAllTodos();

              },
              style: TextButton.styleFrom(primary: Colors.red),
              child: Text('Limpar Tudo'))
        ],
      ),
    );
  }

  void deletAllTodos(){

    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }

}
