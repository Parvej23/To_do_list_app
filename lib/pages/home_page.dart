import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/pages/todo_details_page.dart';

class HomePages extends StatefulWidget {
  const HomePages({Key? key}) : super(key: key);

  @override
  State<HomePages> createState() => _HomePagesState();
}
class _HomePagesState extends State<HomePages> {
  final _textController= TextEditingController();
  FirebaseFirestore firestore= FirebaseFirestore.instance;
  progressDialog(){
    showDialog(
        context: context,
        builder: (context){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
    );
  }
  Future<void> _writeData() async{
    return showDialog(
        context:context,
        builder: (context){
          return AlertDialog(
            title: Text('Add todo List'),
            content: TextField(
              controller: _textController,
              decoration: InputDecoration(hintText:'Write todo item'),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              },
                  child: Text('Cancel')
              ),
              TextButton(
                  onPressed: ()async{
                    try{
                      firestore.collection('todo').add(
                          {
                            'titles':_textController.text,
                          }
                      ).whenComplete(() {
                        Fluttertoast.showToast(msg: 'Added Successfully');
                        _textController.clear();
                        Navigator.of(context)
                          ..pop()
                          ..pop();
                      });
                    }catch(e){
                      print(e);
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    }
                    _textController.clear();
                    Navigator.pop(context);
                  },
                  child: Text('Submit')
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _todo =
    FirebaseFirestore.instance.collection('todo').snapshots();
    bool isChecked = false;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150.0),
        child: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(48.0),
            ),
          ),
          backgroundColor:Color(0xff502897) ,
          title: Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Text('Todo List',style: TextStyle(fontSize: 28),),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              padding: const EdgeInsets.only(top: 28.0, right: 30),
              icon: Icon(
                Icons.dehaze,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>TodoDetails()));
                // do something
              },
            )
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _todo,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Center(child: Text('Something went wrong'));
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: Text("Loading"));
          }
          return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document){
                Map<String, dynamic> data=
                document.data()! as Map<String, dynamic>;
                return Card(
                  elevation: 0,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              value: isChecked,
                              onChanged: (bool? value) {
                                isChecked = value!;
                              },
                            ),

                            Text(
                              data['titles'],
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList()
          );
        },

      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:Color(0xff502897) ,
        onPressed: (){
          _writeData();
          //WriteData(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

