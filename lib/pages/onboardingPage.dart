import 'package:flutter/material.dart';
import 'package:todo_app/pages/home_page.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor:Color(0xff34733F) ,
        onPressed: (){
         Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePages()));
          //WriteData(context);
        },
        child: Icon(Icons.arrow_forward),
      ),
      body: PageView(
        children: [
          _buildOnboardingPage(
            title: 'Welcome to ToDo!',
            subtitle: 'Write your daily tasks here',
            imageUrl: 'https://raw.githubusercontent.com/fabiospampinato/vscode-todo-plus/master/resources/logo/logo.png',
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage({
    required String title,
    required String subtitle,
    required String imageUrl,
  }) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(imageUrl),
          SizedBox(height: 16.0),
          Text(title, style: TextStyle(fontSize: 24.0)),
          SizedBox(height: 8.0),
          Text(subtitle, style: TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }
}