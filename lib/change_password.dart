import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFF1E3A8A);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back),color: Colors.white,),
        title: Text("Change Password",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Update your password",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Text("Enter your current password and your new password",style: TextStyle(fontSize: 20),),
                ],
              ),
              SizedBox(height: 20,),
              Text("Current Password"),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Current Password",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                        
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              Text("New Password"),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "New Password",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(onPressed: (){}, child: Text("Confirm")),
                ],
              ),
            ],
          ),
        ),),
    );
  }
}