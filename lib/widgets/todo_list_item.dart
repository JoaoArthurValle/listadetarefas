import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({Key? key, required this.todo, required this.onDelete, required this.checkbox,})
      : super(key: key);

  final Todo todo;
  final Function(Todo) onDelete;
  final Function(Todo) checkbox;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),

      child: Slidable(child: Container(
        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(4),
          color: Colors.grey[300],

        ),

        padding: const EdgeInsets.all(4),
        height: 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Text(
              DateFormat('dd/MM/yyyy - HH:mm').format(todo.dateTime),
              style: TextStyle(

                fontSize: 12,

              ),

            ),
            Text(
              todo.title,
              style: TextStyle(

                fontSize: 16,
                fontWeight: FontWeight.w600,

              ),

            ),

          ],

        ),

      ),
        actionExtentRatio: 0.25,
        actionPane: const SlidableStrechActionPane(),
        secondaryActions: [

          IconSlideAction(

            color: Colors.red,
            icon: Icons.delete,
            caption: 'Deletar',
            onTap: () {

              onDelete(todo);
            },

          ),
          IconSlideAction(

            color: Colors.green,
            icon: Icons.check_box,
            caption: 'Concluir',
            onTap: () {

              checkbox(todo);
            },
          )
        ],
      ),
    );
  }
}
