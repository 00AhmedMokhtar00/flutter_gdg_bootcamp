import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'note_item.dart';

main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> _notes = [];
  List<String> _dates = [];
  String _theme = 'light';
  TextEditingController _controller = TextEditingController();

  _getData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes = prefs.getStringList('notes')??[];
      _dates = prefs.getStringList('dates')??[];
    });

  }

  _saveData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('notes', _notes);
    prefs.setStringList('dates', _dates);
  }

  _getTheme()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _theme = prefs.getString('theme')??'light';
    });
  }

  _setTheme()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', _theme);
  }

  @override
  void initState() {
    _getData();
    _getTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _theme == 'light'? ThemeData.light():ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter BootCamp'),
          leading: IconButton(
            onPressed: _themeChange,
            icon: Icon(_theme == 'light'?Icons.wb_sunny:Icons.lightbulb_outline, color: Colors.white,),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: _notes.isEmpty?
                    Center(child: Text('Nothing to show yet!', style: TextStyle(fontWeight: FontWeight.bold),))
                    :GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int idx) {
                    return InkWell(
                      onLongPress: () => _deleteNote(idx, context),
                      child: NoteItem(note: _notes[idx], date: _dates[idx],),
                    );
                  },
                  itemCount: _notes.length,
                ),
              ),
              TextField(
                onSubmitted: (_) => _addNote(),
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Enter a note ...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0)),
                ),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                onPressed: _addNote,
                child: Text('Add note'),
              )
            ],
          ),
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

  _addNote(){
    if (_controller.text.isNotEmpty) {
      setState(() {
        _notes.add(_controller.text);
        _dates.add(DateFormat('dd MMM hh:mm a').format(DateTime.now()));
        _controller.clear();
        _saveData();
      });
    }
  }

  _deleteNote(int idx, BuildContext context)async{
    if (await _check(context) == true) {
      setState(() {
        _notes.removeAt(idx);
        _dates.removeAt(idx);
        _saveData();
      });
    }
  }

  _themeChange(){
    setState(() {
      if(_theme == 'light'){
        _theme = 'dark';
      }
      else{
        _theme = 'light';
      }
      _setTheme();
    });
  }

}
