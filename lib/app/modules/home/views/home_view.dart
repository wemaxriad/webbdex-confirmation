// import 'package:flutter/material.dart';
//
// import 'package:get/get.dart';
// import 'package:i_carry/app/widgets/app_drawer.dart';
//
// import '../controllers/home_controller.dart';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../controllers/dashboard_controller.dart';
// import '../../../widgets/app_drawer.dart';
//
// class DashboardView extends GetView<DashboardController> {
//   const DashboardView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF5F5F5),
//
//       drawer: const AppDrawer(),
//       resizeToAvoidBottomInset: true,
//
//       // --------------------- APP BAR ---------------------
//       appBar: AppBar(
//         backgroundColor: const Color(0xff0D3559),
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         toolbarHeight: 150,
//
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ---------- TOP ROW ----------
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Builder(
//                       builder: (context) => IconButton(
//                         icon: const Icon(Icons.menu, color: Colors.white),
//                         onPressed: () => Scaffold.of(context).openDrawer(),
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     const Text(
//                       "Dashboard",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const Padding(
//                   padding: EdgeInsets.only(right: 10),
//                   child: Icon(Icons.flag, color: Colors.white),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 6),
//
//             const Text(
//               "Track Your Order",
//               style: TextStyle(color: Colors.white, fontSize: 14),
//             ),
//             const SizedBox(height: 10),
//
//             _searchBox(),
//           ],
//         ),
//       ),
//
//       // ------------------------ BODY ------------------------
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             padding: const EdgeInsets.only(left: 15, right: 15, bottom: 120),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 15),
//
//                 _balanceCard(),
//                 const SizedBox(height: 10),
//
//                 _shipmentCard(),
//                 const SizedBox(height: 10),
//
//                 deliveredOrderDistribution(),
//                 const SizedBox(height: 10),
//
//                 orderAndShippingSection(),
//                 const SizedBox(height: 10),
//
//                 topBuyerButton(),
//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//
//           // ---------------- FIXED BUTTON ----------------
//           Positioned(
//             left: 15,
//             right: 15,
//             bottom: 20,
//             child: SizedBox(
//               height: 55,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xffF8C237),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 onPressed: () {},
//                 child: const Text(
//                   "Add Shipment",
//                   style: TextStyle(color: Colors.white, fontSize: 17),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ---------------------------------------------------------
//   // SEARCH BOX
//   // ---------------------------------------------------------
//   Widget _searchBox() {
//     return Container(
//       height: 45,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: TextField(
//         decoration: InputDecoration(
//           hintText: "Search By Tracking Number",
//           hintStyle: const TextStyle(
//             color: Colors.grey,
//             fontSize: 15,
//           ),
//           prefixIcon: const Icon(Icons.search, color: Colors.grey),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           contentPadding: EdgeInsets.zero,
//         ),
//       ),
//     );
//   }
//
//   // ---------------------------------------------------------
//   // BALANCE CARD
//   // ---------------------------------------------------------
//   Widget _balanceCard() {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.black12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("Your current balance is", style: TextStyle(fontSize: 15)),
//           const SizedBox(height: 6),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               SizedBox(),
//               Text(
//                 "AED 0.00",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.green,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 15),
//
//           SizedBox(
//             width: double.infinity,
//             child: OutlinedButton(
//               style: OutlinedButton.styleFrom(
//                 side: const BorderSide(color: Color(0xffF8C237)),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30)),
//               ),
//               onPressed: () {},
//               child: const Text(
//                 "Recharge my wallet",
//                 style: TextStyle(color: Color(0xffF8C237)),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ---------------------------------------------------------
//   // SHIPMENT CARD
//   // ---------------------------------------------------------
//   Widget _shipmentCard() {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.black12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Total Shipments",
//             style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 4),
//           const Text(
//             "The below data is for last 30 days",
//             style: TextStyle(fontSize: 13, color: Colors.grey),
//           ),
//           const SizedBox(height: 15),
//
//           Row(
//             children: [
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(100),
//                   border: Border.all(color: Colors.orange, width: 3),
//                 ),
//                 child: const Center(
//                   child: Text(
//                     "2",
//                     style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.orange),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 15),
//
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     ShipmentRow("Total Shipments", 2, Colors.orange),
//                     ShipmentRow("Draft Shipment", 2, Colors.grey),
//                     ShipmentRow("Processed Shipment", 0, Colors.deepOrange),
//                     ShipmentRow("Collected Shipment", 0, Colors.blueGrey),
//                     ShipmentRow("Collecting Shipment", 0, Colors.brown),
//                     ShipmentRow("Outs For Delivery", 0, Colors.blue),
//                     ShipmentRow("Delivered Shipment", 0, Colors.green),
//                     ShipmentRow("Failed Delivery Shipment", 0, Colors.red),
//                     ShipmentRow("RTO Shipment", 0, Colors.black),
//                     ShipmentRow("Cancelled Shipment", 0, Colors.orangeAccent),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ---------------------------------------------------------
//   // DELIVERED ORDER DISTRIBUTION
//   // ---------------------------------------------------------
//   Widget deliveredOrderDistribution() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.withOpacity(0.25)),
//         color: Colors.white,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: const [
//           Text(
//             "Delivered Order Distribution",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//           ),
//           SizedBox(height: 4),
//           Text(
//             "The below data is for last 30 days",
//             style: TextStyle(fontSize: 14, color: Colors.grey),
//           ),
//           SizedBox(height: 140),
//         ],
//       ),
//     );
//   }
//
//   // ---------------------------------------------------------
//   // ORDER & SHIPPING SECTION
//   // ---------------------------------------------------------
//   Widget orderAndShippingSection() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.withOpacity(0.25)),
//         color: Colors.white,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Orders & Shipping",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 12),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               Text("CUMULATIVE ORDERS UP TO DATE",
//                   style: TextStyle(fontSize: 14)),
//               Text("0",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
//             ],
//           ),
//           const SizedBox(height: 10),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               Text("TODAY ORDERS", style: TextStyle(fontSize: 14)),
//               Text("0",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ---------------------------------------------------------
//   // TOP BUYER BUTTON
//   // ---------------------------------------------------------
//   Widget topBuyerButton() {
//     return Center(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey.withOpacity(0.3)),
//           color: Colors.white,
//         ),
//         child: const Text(
//           "Top Buyer",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//       ),
//     );
//   }
// }
//
// // ---------------- Shipment Row ----------------
// class ShipmentRow extends StatelessWidget {
//   final String title;
//   final int count;
//   final Color color;
//
//   const ShipmentRow(this.title, this.count, this.color, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(Icons.circle, size: 10, color: color),
//         const SizedBox(width: 8),
//         Expanded(child: Text(title)),
//         Text(
//           count.toString(),
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
// }
//
