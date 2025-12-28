import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_carry/app/modules/warehouse/model/warehouse_model.dart';
import 'package:i_carry/app/routes/app_pages.dart';

import '../../../utils/constants/colors.dart';
import '../controller/warehouse_controller.dart';

class WarehouseView extends GetView<WarehouseController> {
  const WarehouseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        title: const Text(
          "Warehouse",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: SafeArea(
        child: Obx(
          () => controller.warehouseList.isEmpty
              ? const Center(child: Text("No warehouse locations found."))
              : ListView.builder(
                  padding: const EdgeInsets.all(20.0),
                  itemCount: controller.warehouseList.length,
                  itemBuilder: (context, index) {
                    final warehouse = controller.warehouseList[index];
                    return WarehouseCard(warehouse: warehouse);
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.ADD_WAREHOUSE),
        backgroundColor: CustomColor.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class WarehouseCard extends StatefulWidget {
  final Warehouse warehouse;

  const WarehouseCard({Key? key, required this.warehouse}) : super(key: key);

  @override
  _WarehouseCardState createState() => _WarehouseCardState();
}

class _WarehouseCardState extends State<WarehouseCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _offset = 0.0;
  double _slideLimit = -80.0; // Default value
  final GlobalKey _cardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _animation = Tween<double>(begin: 0.0, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _offset = _animation.value;
        });
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? cardBox = _cardKey.currentContext?.findRenderObject() as RenderBox?;
      if (cardBox != null) {
        setState(() {
          // Set the slide limit to be the height of the card, making the button a square
          _slideLimit = -cardBox.size.height;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _offset = (_offset + details.delta.dx).clamp(_slideLimit, 0.0);
    });
  }

  void _animateTo(double target) {
    _animation = Tween<double>(begin: _offset, end: target)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward(from: 0.0);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_offset.abs() > _slideLimit.abs() / 2) {
      _animateTo(_slideLimit); // Snap open
    } else {
      _animateTo(0.0); // Snap closed
    }
  }

  @override
  Widget build(BuildContext context) {
    final WarehouseController controller = Get.find();

    return GestureDetector(
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Background (Delete Button)
          Container(
            height: 100,
            margin: const EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: _slideLimit.abs(),
                child: InkWell(
                  onTap: () async {
                    final confirmed = await Get.dialog<bool>(
                      AlertDialog(
                        title: const Text('Confirm Deletion'),
                        content: Text(
                            'Are you sure you want to delete ${widget.warehouse.name}?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Get.back(result: false),
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () => Get.back(result: true),
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      controller.deleteWarehouse(widget.warehouse);
                      Get.snackbar(
                        'Warehouse Deleted',
                        '${widget.warehouse.name} has been deleted.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else {
                      _animateTo(0.0); // Close if user cancels
                    }
                  },
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete, color: Colors.white),
                        SizedBox(height: 4),
                        Text('Delete', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Foreground (Card)
          Transform.translate(
            offset: Offset(_offset, 0),
            child: Card(
              key: _cardKey,
              margin: const EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.warehouse.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: CustomColor.primaryColor),
                          onPressed: () {
                            Get.toNamed(Routes.ADD_WAREHOUSE, arguments: widget.warehouse);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.warehouse.location,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ), 
              ),
            ),
          ),
        ],
      ),
    );
  }
}
