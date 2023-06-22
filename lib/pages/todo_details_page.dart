
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class TodoDetails extends StatefulWidget {
  const TodoDetails({Key? key}) : super(key: key);

  @override
  State<TodoDetails> createState() => _TodoDetailsState();
}

class _TodoDetailsState extends State<TodoDetails> {
  TextEditingController _textController= TextEditingController();
  FirebaseFirestore firestore= FirebaseFirestore.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    _textController.dispose();
    super.dispose();
  }
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
  updatedData(context,documentID) async{
    showDialog(
        context: context,
        builder: (context){
          return StatefulBuilder(builder: (context, setState){
            return Dialog(
              child: Container(
                height: 120,
                child: Column(
                  children: [
                    TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.title_outlined,
                          ),
                          hintText: 'Language name'
                      ),
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: ()async{
                          try{
                            progressDialog();
                            firestore.collection('todo').doc(documentID).update(
                                {
                                  'titles':_textController.text,
                                }
                            ).whenComplete(() {
                              Fluttertoast.showToast(msg: 'Update Successfully');
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
                        },
                        child: Text('Update Data'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        }
    );
  }
  final Stream<QuerySnapshot> _languageStream =
  FirebaseFirestore.instance.collection('todo').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor:Color(0xff502897) ,
        title: Text('To-Do Details Page',),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _languageStream,
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
                return Stack(
                  children: [
                    Card(
                      child: Container(
                        height: 44,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text(
                              data['titles'],
                              style: TextStyle(
                                  fontSize: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        color: Colors.grey,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: ()=>updatedData(context,document.id),
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: (){
                                firestore
                                    .collection('todo')
                                    .doc(document.id)
                                    .delete()
                                    .then((value) => Fluttertoast.showToast(
                                    msg:'deleted successfully'
                                )).catchError((error)=>Fluttertoast.showToast(msg: error));
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }).toList()
          );
        },

      ),
    );
  }
}