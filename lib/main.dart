import 'package:flutter/material.dart';

main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> _notes = [];

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter BootCamp'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int idx) {
                  // 0 1
                  return InkWell(
                    onLongPress: () async {
                      if (await _check(context) == true) {
                        setState(() {
                          _notes.removeAt(idx);
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Text(
                        _notes[idx],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                },
                itemCount: _notes.length,
              ),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter a note ...',
                  border: OutlineInputBorder(),
              ),
            ),
            RaisedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    _notes.add(_controller.text);
                    _controller.clear();
                  });

                  print(_notes.toString());
                }
              },
              child: Text('Add note'),
            )
          ],
        ),
      ),
    );
  }

  _check(BuildContext context) async {
    return await showDialog(
        context: context,
        child: AlertDialog(
          content: Text('Are you sure?'),
          actions: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Yes'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('No'),
            ),
          ],
        ));
  }
}
