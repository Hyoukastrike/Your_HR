import 'package:flutter/cupertino.dart';

class toDo{
  String? id;
  String? toDoText;
  bool isDone;

  toDo({
    required this.id,
    required this.toDoText,
    this.isDone = false
  });

  static List<toDo> toDoList(){
    return [
      toDo(id: '01', toDoText: 'Ăn sáng', isDone: true),
      toDo(id: '02', toDoText: 'Ăn trưa', isDone: true),
      toDo(id: '01', toDoText: 'Ăn xế', isDone: true),
      toDo(id: '01', toDoText: 'Ăn tối', isDone: true),
      toDo(id: '01', toDoText: 'Ăn khuya', isDone: true),
    ];
}
}
