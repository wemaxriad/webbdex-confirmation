import 'package:get/get.dart';
import 'package:i_carry/app/modules/warehouse/model/warehouse_model.dart';

class WarehouseController extends GetxController {
  // Observables for the list and pagination
  var warehouseList = <Warehouse>[].obs;
  var itemsPerPage = 10.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWarehouses();
  }

  void fetchWarehouses() {
    // Simulating data fetch from an API
    List<Warehouse> data = [
      Warehouse(name: "Dhaka Mirpur 30", location: "Dhaka, Bangladesh"),
      Warehouse(name: "beirut", location: "Beirut, Lebanon"),
      Warehouse(name: "ABC Exports Ltd.", location: "London, UK"),
      Warehouse(name: "XYZ Imports Inc.", location: "New York, USA"),
      Warehouse(name: "mirpur25", location: "Dhaka, Bangladesh"),
    ];
    warehouseList.assignAll(data);
  }

  void addWarehouse(Warehouse warehouse) {
    warehouseList.add(warehouse);
  }

  void updateWarehouse(Warehouse warehouse) {
    // The warehouse object is passed by reference, so its properties are already updated.
    // We just need to refresh the list to update the UI.
    warehouseList.refresh();
  }

  void deleteWarehouse(Warehouse warehouse) {
    warehouseList.remove(warehouse);
  }

  void updatePerPage(int value) {
    itemsPerPage.value = value;
  }
}
