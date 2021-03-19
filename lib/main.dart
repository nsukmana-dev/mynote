import 'package:flutter/material.dart';
import 'package:mynote/database.dart';
import 'Note.dart';
import 'screen/NewNoteScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Notes',
      home: MyHomePage(title: 'My Notes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Note>> notes;
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadNote();
  }

  loadNote() {
    setState(() {
      notes = dbHelper.getNotes();
    });
  }

  editNote(context, currentItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NewNoteScreen(oldNote: currentItem)),
    );
  }

  removeNote(noteId) {
    dbHelper.deleteNote(noteId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
          future: notes,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0)
                return Center(child: Text("still emptys"));

              return Container(
                  child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final currentItem = snapshot.data[index];

                  // return ListTile(
                  //   title: Text('${currentItem.title}'),
                  // );

                  return Dismissible(
                    key: Key(currentItem.id.toString()),
                    background: Container(color: Colors.red),
                    child: ListTile(
                      title: Text('${currentItem.title}'),
                      onTap: () => editNote(context, currentItem),
                    ),
                    onDismissed: (direction) => removeNote(currentItem.id),
                  );
                },
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text("error fetching notes"));
            } else {
              return CircularProgressIndicator();
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewNoteScreen()),
          );
        },
        tooltip: 'New',
        child: Icon(Icons.add),
      ),
    );
  }
}
