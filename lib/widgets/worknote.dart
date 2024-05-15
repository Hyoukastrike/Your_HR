import 'package:ats_recruitment_system/widgets/todo_items.dart';
import 'package:ats_recruitment_system/models/todo.dart';
import 'package:flutter/material.dart';


class WorkNote extends StatefulWidget {
  const WorkNote({super.key});

  @override
  State<WorkNote> createState() => _WorkNoteState();
}

class _WorkNoteState extends State<WorkNote> {
  final toDoList = toDo.toDoList();
  final toDoController = TextEditingController();
  List<toDo> searchToDo = [];

  @override
  void initState() {
    searchToDo = toDoList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: const Text('Ghi chú công việc'),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 50, bottom: 20),
                        child: const Text(
                          'Việc Cần Làm',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      for(toDo todo in searchToDo)
                        ToDoItem(
                          todo: todo,
                          onToDoChange: _handleToDoChange,
                          onDeleteItem: _deleteToDoItem,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                      left: 20,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0,0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: toDoController,
                      decoration: const InputDecoration(
                        hintText: 'Thêm việc ghi chú',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                  ),
                  child: ElevatedButton(
                    onPressed: (){
                      _addToDoItem(toDoController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(60, 60),
                      elevation: 10
                    ),
                    child: const Text(
                      '+',
                      style: TextStyle(
                        fontSize: 40
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _handleToDoChange(toDo todo){
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id){
    setState(() {
      toDoList.removeWhere((item) => item.id == id);
    });
  }

  void _addToDoItem(String text){
    setState(() {
      toDoList.add(toDo(id: DateTime.now().microsecondsSinceEpoch.toString(), toDoText: text));
    });
    toDoController.clear();
  }

  void _runFilter(String keyWord){
    List<toDo> results = [];
    if(keyWord.isEmpty){
      results = toDoList;
    }else{
      results = toDoList
          .where((item) => item.toDoText!
          .toLowerCase()
          .contains(keyWord.toLowerCase()))
          .toList();
    }

    setState(() {
      searchToDo = results;
    });
  }

  Widget searchBox(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: Colors.black,
            width: 2
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(Icons.search, color: Colors.black, size: 20,),
            prefixIconConstraints: BoxConstraints(
              maxHeight: 20,
              minWidth: 25,
            ),
            border: InputBorder.none,
            hintText: "Tìm kiếm",
            hintStyle: TextStyle(
                color: Colors.grey
            )
        ),
      ),
    );
  }
}
