// import 'package:flutter/material.dart';

// class UploadPage extends StatelessWidget {
//   final Color primaryColor = Color(0xFF1E3A8A);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: Text("Unggahan Baru",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
//         leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back),),
//       ),
//       body:Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(backgroundImage: AssetImage("images/profile1.png"),),
//                 SizedBox(width: 30,),
//                 Text("Valerio Liuz Kienata",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
//               ],
//             ),
//             SizedBox(height: 15,),
//             Expanded(
//               child: TextField(
//                 maxLines: 10,
//                 decoration: InputDecoration(
//                   hintText: "Tulis Sesuatu...",
//                   filled: true,
//                   fillColor: const Color.fromARGB(255, 218, 213, 213),
//                   contentPadding: EdgeInsets.all(20),
//                   border:OutlineInputBorder(
//                     borderSide: BorderSide(
//                       width: 0,
//                       style: BorderStyle.none
//                     )
//                   )
//                 ),
//               ))
//           ],
//         ),
//         ),
        
//     );
//   }
// }

import 'package:flutter/material.dart';

class UploadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          "Unggahan Baru",
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("images/profile1.png"),
                ),
                SizedBox(width: 16),
                Text(
                  "Valerio Liuz Kienata",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: TextField(
                maxLines: null,
                expands: true,
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                ),
                decoration: InputDecoration(
                  hintText: "Tulis Sesuatu...",
                  hintStyle: TextStyle(
                    color: theme.hintColor,
                  ),
                  filled: true,
                  fillColor: theme.cardColor,
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
