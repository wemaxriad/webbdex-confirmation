import 'package:get/get.dart';
import 'package:i_carry/app/routes/app_pages.dart';
import 'package:i_carry/app/services/shipment_data_service.dart';

class ShipmentsController extends GetxController {
  final ShipmentDataService _shipmentDataService = Get.find<ShipmentDataService>();
  
  var title = "Shipments".obs;
  var isLoading = false.obs;

  // The list that is displayed on the screen (can be filtered).
  var shipmentsList = <Map<String, dynamic>>[].obs;

  // Tracks the expanded card using its unique tracking ID.
  var expandedTrackingId = ''.obs;

  // Holds the current search text.
  var searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadShipments();

    // Listen for changes in the master shipment list and refresh.
    _shipmentDataService.allShipments.listen((_) {
      _filterShipments();
    });

    // When the search text changes, wait 300ms and then filter the list.
    debounce(searchText, (_) => _filterShipments(),
        time: const Duration(milliseconds: 300));
  }

  void loadShipments() {
    isLoading.value = true;
    _filterShipments();
    isLoading.value = false;
  }

  void _filterShipments() {
    final query = searchText.value.toLowerCase();
    final allShipments = _shipmentDataService.allShipments;

    if (query.isEmpty) {
      // If the query is empty, show the entire original list.
      shipmentsList.assignAll(allShipments);
    } else {
      // Otherwise, filter the original list based on the query.
      shipmentsList.assignAll(allShipments.where((shipment) {
        final valuesToSearch = [
          shipment['tracking'],
          shipment['status'],
          shipment['from'],
          shipment['to'],
          shipment['sender'],
          shipment['carrier'],
          shipment['recipient']
        ];
        return valuesToSearch
            .any((value) => value?.toString().toLowerCase().contains(query) ?? false);
      }).toList());
    }
  }

  void toggleExpand(String trackingId) {
    if (expandedTrackingId.value == trackingId) {
      // If the tapped card is already expanded, collapse it.
      expandedTrackingId.value = '';
    } else {
      // Otherwise, expand the tapped card.
      expandedTrackingId.value = trackingId;
    }
  }

  void startNewShipment() {
    // Clear all data from the service before starting a new flow
    _shipmentDataService.clearData();
    Get.toNamed(Routes.LOCATION);
  }
}
