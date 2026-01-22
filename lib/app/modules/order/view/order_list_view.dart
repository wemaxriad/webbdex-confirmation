import 'package:confirmation_agent_app/app/modules/order/controller/order_controller.dart';
import 'package:confirmation_agent_app/app/utils/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/order_model.dart';
import '../../order/controller/order_details_controller.dart';
import '../../order/view/order_details_view.dart';
import '../controller/order_call_controller.dart';
import '../model/orderModel.dart';
import 'order_call_screen_page.dart';

class OrderListView extends GetView<MyOrdersController> {
  const OrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: "Pending"),
              Tab(text: "Assign"),
              Tab(text: "Confirmed"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                /// 🔴 Pending
                Column(
                  children: [
                    tabSearchBar(
                      controller: controller.pendingSearchCtrl,
                      onSearch: () => controller.getOrderHistoryData(reset: true),
                    ),
                    Expanded(
                      child: Obx(() => ordersList(
                        controller.orderList,
                        controller.isMoreLoading.value,
                            () => controller.getOrderHistoryData(),
                      )),
                    ),
                  ],
                ),

                /// 🟢 Confirmed
                Column(
                  children: [
                    tabSearchBar(
                      controller: controller.assignSearchCtrl,
                      onSearch: () => controller.getAssignOrderHistoryData(reset: true),
                    ),
                    Expanded(
                      child: Obx(() => assignOrdersList(
                        controller.assignOrderList,
                        controller.assignOrderIsMoreLoading.value,
                            () => controller.getAssignOrderHistoryData(),
                      )),
                    ),
                  ],
                ),

                /// ⚫ Canceled
                Column(
                  children: [
                    tabSearchBar(
                      controller: controller.confirmedSearchCtrl,
                      onSearch: () => controller.getConfirmedOrderHistoryData(reset: true),
                    ),
                    Expanded(
                      child: Obx(() => confirmOrdersList(
                        controller.confirmedOrderList,
                        controller.confirmedOrderIsMoreLoading.value,
                            () => controller.getConfirmedOrderHistoryData(),
                      )),
                    ),
                  ],
                ),
              ],
            )

          ),
        ],
      ),
    );
  }

  Widget tabSearchBar({
    required TextEditingController controller,
    required VoidCallback onSearch,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          /// 🔍 SEARCH FIELD
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSearch(),
              decoration: InputDecoration(
                hintText: 'Order ID / Customer Name / Phone',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: const Icon(Icons.search, size: 22),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {
                    controller.clear();
                    onSearch();
                  },
                )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),topLeft: Radius.circular(10)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 0),

          /// 🔵 SEARCH BUTTON
          SizedBox(
            height: 53,
            child: ElevatedButton.icon(
              onPressed: onSearch,
              icon: const Icon(Icons.search, size: 18,color: Colors.white,),
              label: const Text(
                'Search',
                style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding:
                const EdgeInsets.symmetric(horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),topRight: Radius.circular(10)),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget ordersList(
      List<OrderList> orderList,
      bool isLoading,
      VoidCallback loadMore,
      ) {
    return RefreshIndicator(
      onRefresh: controller.refreshOrders,
      child: Obx(() {
        if (controller.isMoreLoading.value &&
            orderList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (orderList.isEmpty) {
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
              loadMore();
              // controller.getOrderHistoryData();
            }
            return false;
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: orderList.length +
                (controller.isMoreLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == orderList.length) {
                return const Padding(
                  padding: EdgeInsets.all(12),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final item = orderList[index];
              return _OrderCard(item,context);
            },
          ),
        );
      }),
    );
  }

  Widget assignOrdersList(
      List<OrderList> orderList,
      bool isLoading,
      VoidCallback loadMore,
      ) {
    return RefreshIndicator(
      onRefresh: controller.refreshOrders,
      child: Obx(() {
        if (controller.assignOrderIsMoreLoading.value &&
            orderList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (orderList.isEmpty) {
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
                !controller.assignOrderIsMoreLoading.value) {
              loadMore();
              // controller.getOrderHistoryData();
            }
            return false;
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: orderList.length +
                (controller.assignOrderIsMoreLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == orderList.length) {
                return const Padding(
                  padding: EdgeInsets.all(12),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final item = orderList[index];
              return _OrderCard(item,context);
            },
          ),
        );
      }),
    );
  }

  Widget confirmOrdersList(
      List<OrderList> orderList,
      bool isLoading,
      VoidCallback loadMore,
      ) {
    return RefreshIndicator(
      onRefresh: controller.refreshOrders,
      child: Obx(() {
        if (controller.confirmedOrderIsMoreLoading.value &&
            orderList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (orderList.isEmpty) {
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
                !controller.confirmedOrderIsMoreLoading.value) {
              loadMore();
              // controller.getOrderHistoryData();
            }
            return false;
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: orderList.length +
                (controller.confirmedOrderIsMoreLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == orderList.length) {
                return const Padding(
                  padding: EdgeInsets.all(12),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final item = orderList[index];
              return _OrderCard(item,context);
            },
          ),
        );
      }),
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
          controller.getConfirmedOrderDetailsData(order.id.toString(),order.tenantId.toString());
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
                  if (order.confirmationStatus != "approved")
                    ElevatedButton.icon(
                      onPressed: () => order.confirmationStatus == 'pending' ? showChangeStatusAssignDialog(order) : showChangeStatusConfirmDialog(order),
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
                ],
              ),
              const Divider(height: 24),
              /// 👤 Customer Name + Date
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      order.customerName ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    order.createdAt ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// 📞 Phone + Call Button (only if not pending)
              if (order.confirmationStatus.toString() != 'pending')
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.phone_outlined,
                            size: 16,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            order.customerPhone ?? 'N/A',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final callCtrl = Get.put(CallController());
                              Get.to(() => const OrderCallScreenPage());
                              callCtrl.makeCall(order,
                                  order.customerPhone ?? '',
                              );
                            },
                            // onPressed: () => openDialPad("${order.customerPhone}"),
                            icon: const Icon(Icons.call, size: 16,color: Colors.white),
                            label: const Text(
                              'Call',
                              style: TextStyle(fontSize: 12,color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff39C367),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(text: order.customerEmail ?? ''),
                        );
                        Get.snackbar(
                          'Copied',
                          'Email copied to clipboard',
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(12),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.email_outlined,
                              size: 16,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              order.customerEmail ?? 'N/A',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          const Icon(
                            Icons.copy,
                            size: 14,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              const Divider(height: 20),
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
                  Spacer(),
                  statusBadge(order.confirmationStatusName!),
                ],
              ),
              Text('Preferred Language: ${order.confirmationPreferredLanguage ?? 'N/A'}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 📞 Open phone dial pad
  Future<void> openDialPad(String phone) async {
    final Uri uri = Uri.parse("tel:$phone");

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      Get.snackbar("Error", "Could not open dial pad");
    }
  }

  Widget statusBadge(String status) {
    Color bgColor;
    switch (status) {
      case "Confirmed":
        bgColor = const Color(0xff39C367);
        break;
      case "Approved":
        bgColor = Colors.green;
        break;
        case "Assign":
        bgColor = Colors.orange;
        break;
        case "De-Assign":
        bgColor = Colors.indigoAccent;
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

  void showChangeStatusConfirmDialog(OrderList order) {
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
                        color: primaryColor,
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
                        color: primaryColor,
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
                        onPressed: controller.showImageSourceSheet,
                          icon: const Icon(Icons.image_outlined),
                          label: const Text("Attach Image"),
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
                Obx(() {
                  if (controller.attachmentAudioName.value == null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                              controller.attachmentAudioName.value!,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: controller.clearAudioAttachment,
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
                                : () => controller.submitStatusChange(order.id.toString(),order.tenantId.toString(),controller.selectedStatus.value),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
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

  void showChangeStatusAssignDialog(OrderList order) {
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
                      "Confirmation Status",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: primaryColor,
                        size: 30,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),
                const Text(
                  "Select Status *",
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
                        controller.assignStatusOptions.contains(
                          controller.assignSelectedStatus.value,
                        )
                            ? controller.assignSelectedStatus.value
                            : controller.assignStatusOptions.first,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        onChanged: (String? newValue) {
                          controller.assignSelectedStatus.value = newValue??'';
                        },
                        items: controller.assignStatusOptions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color:Colors.black,
                              ),
                            ),
                          );
                        })
                            .toList(),
                      ),
                    ),
                  ),
                ),

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
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () => controller.submitStatusChange(order.id.toString(),order.tenantId.toString(),controller.assignSelectedStatus.value),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
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
                      )
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


}
