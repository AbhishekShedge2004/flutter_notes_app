import 'package:database_new/db/db_helper.dart';
import 'package:database_new/model/user_model.dart';
import 'package:database_new/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SignupPage extends StatelessWidget{
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Signup"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10
          ),
          Text("Create Account", style: TextStyle(fontSize: 21),),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(21)),
                    hintText: "Enter Name",
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(21)),
                    hintText: "Enter Email"
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: passController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(21)),
                    hintText: "Enter password"
                  ),
                )
              ],
            ),
          ),
          ElevatedButton(onPressed: () async{
            DBHelper db = DBHelper.getInstance();
            
            var check = await db.addNewUser(UserModel(
                uName: nameController.text.toString(),
                uEmail: emailController.text.toString(),
                uPass: passController.text.toString()
            )
            );

            if(check){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return LoginPage();
              },));
            }else{
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email already registered!!"), action: SnackBarAction(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  },));
              },label: "Login Now",),));
            }

          }, child: Text("Sign-Up")),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an Account,"),
              InkWell(
                onTap: () {

                },
                child: Text("Login now"),
              )
            ],
          )
        ],
      ),
    );

  }
}