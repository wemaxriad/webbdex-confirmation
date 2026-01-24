import 'package:confirmation_agent_app/app/modules/order/controller/order_controller.dart';
import 'package:confirmation_agent_app/app/utils/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../globalController/global_controller.dart';
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
    final globalController = Get.find<GlobalController>();
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: globalController.t("pending")),
              Tab(text: globalController.t("assign")),
              Tab(text: globalController.t("confirmed")),
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
                      hintText: globalController.t("search_hint"),
                    ),
                    Expanded(
                      child: Obx(() => ordersList(
                        controller.orderList,
                        controller.isMoreLoading.value,
                            () => controller.getOrderHistoryData(),
                        emptyText: globalController.t("no_order_list"),
                      )),
                    ),
                  ],
                ),

                /// 🟢 Assign
                Column(
                  children: [
                    tabSearchBar(
                      controller: controller.assignSearchCtrl,
                      onSearch: () => controller.getAssignOrderHistoryData(reset: true),
                      hintText: globalController.t("search_hint"),
                    ),
                    Expanded(
                      child: Obx(() => assignOrdersList(
                        controller.assignOrderList,
                        controller.assignOrderIsMoreLoading.value,
                            () => controller.getAssignOrderHistoryData(),
                        emptyText: globalController.t("no_order_list"),
                      )),
                    ),
                  ],
                ),

                /// ⚫ Confirmed
                Column(
                  children: [
                    tabSearchBar(
                      controller: controller.confirmedSearchCtrl,
                      onSearch: () => controller.getConfirmedOrderHistoryData(reset: true),
                      hintText: globalController.t("search_hint"),
                    ),
                    Expanded(
                      child: Obx(() => confirmOrdersList(
                        controller.confirmedOrderList,
                        controller.confirmedOrderIsMoreLoading.value,
                            () => controller.getConfirmedOrderHistoryData(),
                        emptyText: globalController.t("no_order_list"),
                      )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tabSearchBar({
    required TextEditingController controller,
    required VoidCallback onSearch,
    String? hintText,
  }) {
    final globalController = Get.find<GlobalController>();
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
                hintText: hintText ?? globalController.t('order_id_customer_name_phone'),
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
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10), topLeft: Radius.circular(10)),
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
              icon: const Icon(
                Icons.search,
                size: 18,
                color: Colors.white,
              ),
              label: Text(
                Get.find<GlobalController>().t('search'),
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10)),
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
      VoidCallback loadMore, {
        String emptyText = '',
      }) {
    return RefreshIndicator(
      onRefresh: controller.refreshOrders,
      child: Obx(() {
        if (isLoading && orderList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (orderList.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 300),
              Center(child: Text(emptyText)),
            ],
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (scroll) {
            if (scroll.metrics.pixels == scroll.metrics.maxScrollExtent &&
                !isLoading) {
              loadMore();
            }
            return false;
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: orderList.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == orderList.length) {
                return const Padding(
                  padding: EdgeInsets.all(12),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final item = orderList[index];
              return _OrderCard(item, context);
            },
          ),
        );
      }),
    );
  }

// assignOrdersList and confirmOrdersList can simply reuse ordersList with their own params

  Widget assignOrdersList(
      List<OrderList> orderList,
      bool isLoading,
      VoidCallback loadMore, {
        String emptyText = '',
      }) =>
      ordersList(orderList, isLoading, loadMore, emptyText: emptyText);

  Widget confirmOrdersList(
      List<OrderList> orderList,
      bool isLoading,
      VoidCallback loadMore, {
        String emptyText = '',
      }) =>
      ordersList(orderList, isLoading, loadMore, emptyText: emptyText);




  Widget _OrderCard(OrderList order, BuildContext context) {
    final globalController = Get.find<GlobalController>();

    return Card(
      elevation: 2,
      margin: const EdgeInsetsDirectional.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          controller.getConfirmedOrderDetailsData(order.id.toString(), order.tenantId.toString());
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
                          '${globalController.t("order_id")}: #${order.id}',
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
                      onPressed: () => order.confirmationStatus == 'pending'
                          ? showChangeStatusAssignDialog(order)
                          : showChangeStatusConfirmDialog(order),
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
                      label: Text(
                        globalController.t('change_status'),
                        style: const TextStyle(
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
                      order.customerName ?? globalController.t('not_available'),
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
                            order.customerPhone ?? globalController.t('not_available'),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final callCtrl = Get.put(CallController());
                              Get.to(() => const OrderCallScreenPage());
                              callCtrl.makeCall(order, order.customerPhone ?? '');
                            },
                            icon: const Icon(Icons.call, size: 16, color: Colors.white),
                            label: Text(
                              globalController.t('call'),
                              style: const TextStyle(fontSize: 12, color: Colors.white),
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
                          globalController.t('copied'),
                          globalController.t('email_copied_to_clipboard'),
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
                              order.customerEmail ?? globalController.t('not_available'),
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
                      Text(
                        '${globalController.t("billed_amount")}: ',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "${order.totalAmount}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Spacer(),
                  statusBadge(order.confirmationStatusName!),
                ],
              ),
              Text(
                '${globalController.t("preferred_language")}: ${order.confirmationPreferredLanguage ?? globalController.t('not_available')}',
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
    final globalController = Get.find<GlobalController>();

    controller.selectedStatus.value = globalController.t('select_status'); // localize default value
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
                    Text(
                      globalController.t('change_status'),
                      style: const TextStyle(
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
                Text(
                  globalController.t('select_status') + '*',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
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
                        value: controller.statusOptions.contains(
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
                              value == globalController.t('select_status')
                                  ? value
                                  : globalController.t(value),
                              style: TextStyle(
                                color: value == globalController.t('select_status')
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  globalController.t('note'),
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 5),
                TextField(
                  maxLines: 4,
                  onChanged: controller.updateStatusNotes,
                  decoration: InputDecoration(
                    hintText: globalController.t('add_notes_here'),
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
                Text(
                  globalController.t('attachment'),
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
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
                          label: Text(globalController.t('attach_image')),
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
                          label: Text(globalController.t('attach_audio')),
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
                          child: Text(
                            globalController.t('cancel'),
                            style: const TextStyle(
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
                            onPressed: controller.selectedStatus.value ==
                                globalController.t('select_status')
                                ? null
                                : () => controller.submitStatusChange(
                              order.id.toString(),
                              order.tenantId.toString(),
                              controller.selectedStatus.value,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              globalController.t('yes_sure'),
                              style: const TextStyle(
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

    final globalController = Get.find<GlobalController>();
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
                    Text(
                      globalController.t('confirmation_status'),
                      style: const TextStyle(
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
                Text(
                  globalController.t('select_status') + ' *',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
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
                        value: controller.assignStatusOptions.contains(
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
                          controller.assignSelectedStatus.value = newValue ?? '';
                        },
                        items: controller.assignStatusOptions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              globalController.t(value),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
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
                          child: Text(
                            globalController.t('cancel'),
                            style: const TextStyle(
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
                          onPressed: () => controller.submitStatusChange(
                            order.id.toString(),
                            order.tenantId.toString(),
                            controller.assignSelectedStatus.value,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            globalController.t('yes_sure'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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



}
