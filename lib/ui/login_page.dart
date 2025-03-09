import 'package:database_new/db/db_helper.dart';
import 'package:database_new/ui/home_page.dart';
import 'package:database_new/ui/signup_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget{
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Text("Hi, Welcome back!", style: TextStyle(fontSize: 21),),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(21)),
                    hintText: "Enter Email",
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: passController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(21)),
                    hintText: "Enter Password"
                  ),
                )
              ],
            ),
          ),
          ElevatedButton(onPressed: () async{
            DBHelper db = DBHelper.getInstance();

            bool check = await db.authenticateUser(emailController.text, passController.text);
            if(check){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return HomePage();
              },));
            }else{
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid credential")));
            }

          }, child: Text('Login')),
          SizedBox(
            height:15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("New User?"),
              InkWell(
                child: Text("Create Account now"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SignupPage();
                  },));

                },
              )
            ],
          )
        ],
      ),
    );
  }
}