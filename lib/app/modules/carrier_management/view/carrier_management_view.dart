import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_carry/app/modules/carrier_management/controller/carrier_management_controller.dart';
import 'package:i_carry/app/routes/app_pages.dart';
import 'package:i_carry/app/utils/constants/colors.dart';
import 'package:intl/intl.dart';

class CarrierManagementView extends GetView<CarrierManagementController> {
  const CarrierManagementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        title: const Text('Carrier Management'),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () => Get.toNamed(Routes.ADD_CARRIER, arguments: {'isEditMode': false}),
          icon: const Icon(Icons.add),
          label: const Text('Add Carrier'),
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColor.secondaryColor,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 130,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildInfoCard(
                        title: 'Total Carriers',
                        count: controller.totalCarriers.toString(),
                        subtitle: 'All configured carriers',
                        icon: Icons.local_shipping_outlined,
                      ),
                      const SizedBox(width: 16),
                      _buildInfoCard(
                        title: 'Active Carriers',
                        count: controller.activeCarriers.toString(),
                        subtitle: 'Ready for shipping',
                        icon: Icons.check_circle_outline,
                      ),
                      const SizedBox(width: 16),
                      _buildInfoCard(
                        title: 'Inactive Carriers',
                        count: controller.inactiveCarriers.toString(),
                        subtitle: 'Currently disabled',
                        icon: Icons.cancel_outlined,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Carrier List',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Manage all your shipping carriers',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.carriers.length,
                  itemBuilder: (context, index) {
                    return _buildCarrierCard(context, controller.carriers[index], index);
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String count,
    required String subtitle,
    required IconData icon,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      elevation: 0.5,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(title, style: TextStyle(color: Colors.grey[600])),
            Row(
              children: [
                Icon(icon, size: 28),
                const SizedBox(width: 8),
                Text(count,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            Text(subtitle, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildCarrierCard(BuildContext context, Map<String, dynamic> carrier, int index) {
    final bool isActive = carrier['status'] == 'Active';
    final lastUpdated = carrier['lastUpdated'] as DateTime;
    final formattedDate = DateFormat('MMM d, yyyy').format(lastUpdated);

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8)),
                    child:
                        const Icon(Icons.domain_outlined, color: Colors.grey)),
                const SizedBox(width: 12),
                Text(carrier['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: isActive
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(carrier['status']!,
                      style: TextStyle(
                          color: isActive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500)),
                ),
                const SizedBox(width: 8),
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'toggle') {
                      controller.toggleCarrierStatus(index);
                    } else if (value == 'delete') {
                      _showDeleteConfirmationDialog(context, index);
                    } else if (value == 'edit') {
                      Get.toNamed(Routes.ADD_CARRIER, arguments: {
                        'isEditMode': true,
                        'carrierData': carrier,
                        'index': index,
                      });
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'toggle',
                      child: Row(children: [
                        Icon(isActive ? Icons.cancel_outlined : Icons.check_circle_outline, size: 20),
                        SizedBox(width: 8),
                        Text(isActive ? 'Deactivate' : 'Activate')
                      ]),
                    ),
                    const PopupMenuItem(
                        value: 'edit',
                        child: Row(children: [
                      Icon(Icons.edit_outlined, size: 20),
                      SizedBox(width: 8),
                      Text('Edit')
                    ])),
                    const PopupMenuItem(
                        value: 'delete',
                        child: Row(children: [
                      Icon(Icons.delete_outline, size: 20),
                      SizedBox(width: 8),
                      Text('Delete')
                    ])),
                  ],
                  icon: const Icon(Icons.more_vert),
                )
              ],
            ),
            const Divider(height: 24),
            const Text('Configuration', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('api_key'),
                const SizedBox(width: 8),
                const Text('secret_key'),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4)),
                  child: const Text('+2 more'),
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Last Updated', style: TextStyle(color: Colors.grey)),
                Text(formattedDate),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 50),
              SizedBox(height: 16),
              Text('Delete Carrier?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            ],
          ),
          content: Text(
            'This will permanently remove the carrier configuration. This action cannot be undone.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(width: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Yes, delete it!'),
              onPressed: () {
                controller.deleteCarrier(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
