// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// class LocationList extends StatelessWidget {
//   const LocationList({
//     Key? key,
//     required this.location,
//     required this.press,
//   }) : super(key: key);
//
//   final String location;
//   final VoidCallback press;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ListTile(
//           onTap: press,
//           horizontalTitleGap: 0,
//             leading: SvgPicture.asset('images/Super.avif'),
//           title: Text(location,
//           maxLines: 2,
//               overflow: TextOverflow.ellipsis,),
//         ),
//         Divider(height: 2,
//         thickness: 2,
//         color: Colors.black,)
//       ],
//     );
//   }



// //דף שאני רוצה לקרוא לUrL שיביא לי קורדינטות של המיקום אליו המשלוח צריך להיות למשוך את המקום מדף ה-DELIVERY וזה פותח לי מפה עם 2 מקומות- הראשון יקום העסק השני המיקום של המשלוח


import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../pages/order.dart';
import '../pages/deliveryPage.dart';

class MapPage extends StatefulWidget {
  static const String id = "map";

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
   late UserDetails userAddress;
  late LatLng userLocation; // Store the user's location

  // @override
  // void initState() {
  //   super.initState();
  //  // getUserLocation(); // Call the function to get the user's location
  // }
//   Future<void> getUserLocation() async {
//     // Use the address from UserDetails
//     final address = userAddress.selectedStreet; // Assuming userAddress is your UserDetails object
// print('addresssss: '+address);
//     // Call the function to get the location
//     final location = await getAddressLatLng(address);
//     print(location);
//     if (location != null) {
//       setState(() {
//         userLocation = LatLng(location.latitude, location.longitude);
//       });
//     } else {
//       // Handle failure to fetch location
//       print('Failed to fetch location.');
//     }
//   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Map Page'),
        ),
         body: Center(
      child: Container(child: Text(userAddress.selectedStreet,
        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
        //   child: Column(
        //       children: [
        //     // if (routePoints.isNotEmpty)
        //     Container(
        //       width: 100,
        //       height: 200,
        //       decoration: BoxDecoration(color: Colors.black),
        //       child: userLocation != null
        //           ? FlutterMap(
        //         options: MapOptions(
        //           center: LatLng(29.544721530634188, 34.93183076742634),
        //           zoom: 10,
        //         ),
        //         children: [
        //           TileLayer(
        //             urlTemplate:
        //                 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        //             userAgentPackageName: 'com.example.markettest',
        //           ),
        //           PolylineLayer(
        //             polylines: [
        //               Polyline(
        //                 points: [
        //                   userLocation // the address of user
        //                 ],
        //                 color: Colors.blue,
        //                 strokeWidth: 10,
        //               ),
        //             ],
        //           )
        //         ],
        //       ): CircularProgressIndicator(), // Show a loading indicator while userLocation is null
        //     ),
        //   ]),
        // )
     ));
  }
}
