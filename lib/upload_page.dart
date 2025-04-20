import 'package:flutter/material.dart';

class UploadPage extends StatelessWidget {
  final Color primaryColor = Color(0xFF1E3A8A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Unggahan Baru",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back),),
      ),
      body:Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(backgroundImage: AssetImage("assets/1.png"),),
                SizedBox(width: 30,),
                Text("Valerio Liuz Kienata",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
              ],
            ),
            SizedBox(height: 15,),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Tulis Sesuatu...",
                  contentPadding: EdgeInsets.all(20),
                  border:OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none
                    )
                  )
                ),
              ))
          ],
        ),
        ),
        
    );
  }
}
