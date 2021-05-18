// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class UserPosts {
//   List postList;
//   UserPosts({@required this.postList});
//   Widget getUserPost()
//   {
//     Card(
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         children: [
//           ListTile(
//             leading: Icon(Icons.arrow_drop_down_circle),
//             title: Text(
//                 "NAME: " + postsList[index]()['name']),
//             subtitle: Text(
//               postsList[index]()['description'],
//               style: TextStyle(
//                   color: Colors.black.withOpacity(0.6)),
//             ),
//           ),
//           Container(
//             height: 400.0,
//             width: 400.0,
//             child: getImage(postsList[index]()['link']),
//           ),
//           // Container(
//           //   width: 160,
//           //   height: 160,
//           //   decoration: BoxDecoration(
//           //     border: Border.all(
//           //         width: 4,
//           //         color: Theme.of(context)
//           //             .scaffoldBackgroundColor),
//           //     // boxShadow: [
//           //     //   BoxShadow(
//           //     //       spreadRadius: 2,
//           //     //       blurRadius: 10,
//           //     //       color:
//           //     //           Colors.black.withOpacity(0.1),
//           //     //       offset: Offset(0, 10))
//           //     // ],
//
//           //     shape: BoxShape.circle,
//           //   ),
//
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               "Location: ",
//               style: TextStyle(
//                   color: Colors.black.withOpacity(0.6)),
//             ),
//           ),
//           ButtonBar(
//             alignment: MainAxisAlignment.start,
//             children: [
//               Text('Phone Number: ' +
//                   postsList[index]()['phoneno']),
//               FlatButton(
//                 onPressed: () {
//                   // Perform some action
//                 },
//                 child: const Text('LOCATE'),
//               ),
//             ],
//           ),
//           //Image.asset('assets/card-sample-image.jpg'),
//         ],
//
//       ),
//     );
//   }
// }
