import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String hello = 'Hello Diana';
  final List<Map<String, dynamic>> _tasks = [];

  final TextEditingController _task = TextEditingController();

  final globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: const Text('D\'s To do'),
        centerTitle: true,
      ),
      body: Center(
        child: _tasks.isEmpty
            ? const Text(
                "There are no tasks\n add some",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              )
            : ListView(
                children: List.generate(
                    _tasks.length,
                    (i) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Checkbox(
                                  value: _checked(i),
                                  onChanged: (status) {
                                    setState(() {
                                      _tasks[i]['done'] = status;
                                    });
                                  }),
                              Text(
                                "${i + 1}.${_tasks[i]['title']}",
                                style: TextStyle(
                                    color: i.isEven ? Colors.grey : Colors.blue,
                                    fontSize: 24,
                                    decoration: _checked(i)
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none),
                              ),
                            ],
                          ),
                        )),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          globalKey.currentState!.showBottomSheet((context) => _add());
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _add() => Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        height: MediaQuery.of(context).size.height * .25,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "New List",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _task,
                decoration: InputDecoration(
                    hintText: "Learn HTML", icon: Icon(Icons.task)),
                onFieldSubmitted: (t) {
                  if (t.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Specify the task')));
                    return;
                  }
                  _addTask(t);
                },
              ),
            )
          ],
        ),
      );

  Future<void> _addTask(String task) async {
    var t = {"done": false, "title": task};
    setState(() {
      _tasks.add(t);
       _task.clear();
    });
   
    Navigator.of(context).pop();
  }

  bool _checked(int i) => _tasks[i]['done'];
}
