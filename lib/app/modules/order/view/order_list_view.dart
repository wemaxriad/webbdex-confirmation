import 'package:confirmation_agent_app/app/modules/order/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/order_model.dart';
import '../../order/controller/order_details_controller.dart';
import '../../order/view/order_details_view.dart';
import '../model/orderModel.dart';

class OrderListView extends GetView<MyOrdersController> {
  const OrderListView({super.key});

  static const Color kMainColor = Color(0xffFF3B30);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              indicatorColor: kMainColor,
              labelColor: kMainColor,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: "Pending"),
                Tab(text: "Confirmed"),
                Tab(text: "Canceled"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _ordersList("Pending"),
                _ordersList("Confirmed"),
                _ordersList("Canceled"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ordersList(String filterStatus) {
    return RefreshIndicator(
      onRefresh: controller.refreshOrders,
      child: Obx(() {
        if (controller.isLoading.value &&
            controller.orderList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.orderList.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 300),
              Center(child: Text("No order list")),
            ],
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (scroll) {
            if (scroll.metrics.pixels ==
                scroll.metrics.maxScrollExtent &&
                !controller.isMoreLoading.value) {
              controller.getOrderHistoryData();
            }
            return false;
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: controller.orderList.length +
                (controller.isMoreLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.orderList.length) {
                return const Padding(
                  padding: EdgeInsets.all(12),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final item = controller.orderList[index];
              return _OrderCard(item,context);
            },
          ),
        );
      }),
    );
  }

  void showChangeStatusDialog(int orderId) {
    controller.selectedStatus.value = 'Select Status';
    controller.statusNotes.value = '';
    controller.clearAttachment(); // Clear previous attachments

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Change Status",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: kMainColor,
                        size: 30,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),
                const Text(
                  "Select Status*",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 5),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value:
                            controller.statusOptions.contains(
                              controller.selectedStatus.value,
                            )
                            ? controller.selectedStatus.value
                            : controller.statusOptions.first,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        onChanged: (String? newValue) {
                          controller.updateSelectedStatus(newValue);
                        },
                        items: controller.statusOptions
                            .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: value == 'Select Status'
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),
                              );
                            })
                            .toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Note",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 5),
                TextField(
                  maxLines: 4,
                  onChanged: controller.updateStatusNotes,
                  decoration: InputDecoration(
                    hintText: 'Add notes here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: kMainColor,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Attachment",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 5),
                Obx(() {
                  if (controller.attachmentName.value == null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OutlinedButton.icon(
                          onPressed: controller.pickImageAttachment,
                          icon: const Icon(Icons.image_outlined),
                          label: const Text("Attach Image"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade700,
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: controller.pickAudioAttachment,
                          icon: const Icon(Icons.mic_none),
                          label: const Text("Attach Audio"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade700,
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              controller.attachmentName.value!,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: controller.clearAttachment,
                          ),
                        ],
                      ),
                    );
                  }
                }),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () => Get.back(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Obx(
                        () => SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            onPressed:
                                controller.selectedStatus.value ==
                                    'Select Status'
                                ? null
                                : () => controller.submitStatusChange(orderId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kMainColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Yes, Sure',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _OrderCard(OrderList order, BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsetsDirectional.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.to(
            () => OrderDetailsView(orderId: order.id!),
            binding: BindingsBuilder(() {
              Get.put(OrderDetailsController(order.id!));
            }),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${order.globalId}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Order ID: #${order.id}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (order.status == "pending")
                    ElevatedButton.icon(
                      onPressed: () => showChangeStatusDialog(order.id!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff39C367),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        minimumSize: Size.zero,
                        elevation: 0,
                        splashFactory: NoSplash.splashFactory, // no ripple
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(
                        Icons.sync_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Change Status',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    statusBadge(order.status!),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Text(' ${order.customerName}'),
                  Spacer(),
                  Text(' ${order.createdAt}'),
                ],
              ),

              Row(
                children: [
                  Text('📞 ${order.customerPhone}'),
                  Spacer(),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.call),
                    label: const Text('Call Customer'),
                    onPressed: () => print(''),
                  ),
                ],
              ),
              Text('📍 ${order.customerEmail}'),


              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Billed Amount: ",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "${order.totalAmount}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget statusBadge(String status) {
    Color bgColor;
    switch (status) {
      case "Confirmed":
        bgColor = const Color(0xff39C367);
        break;
      case "Canceled":
        bgColor = Colors.red;
        break;
      case "Pending":
        bgColor = Colors.orange.shade300;
        break;
      default:
        bgColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        status,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
