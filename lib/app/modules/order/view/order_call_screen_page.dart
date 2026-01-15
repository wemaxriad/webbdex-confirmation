import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/order_call_controller.dart';

class OrderCallScreenPage extends StatelessWidget {
  const OrderCallScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the controller
    final CallController controller = Get.find<CallController>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E2433), Color(0xFF121622)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Top Section (Status & Dynamic Timer)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    Obx(() => Text(
                      controller.callStatus.value,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                    const SizedBox(height: 10),
                    // Dynamic Timer
                    Obx(() => Text(
                      controller.formattedTime,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ],
                ),
              ),

              /// Center Avatar
              const Column(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Color(0xFF4CAF50),
                    child: CircleAvatar(
                      radius: 72,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                ],
              ),

              /// Action Buttons (Speaker & Mute)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(() => _CallActionButton(
                      icon: controller.isSpeaker.value ? Icons.volume_up : Icons.volume_down,
                      label: 'Speaker',
                      isActive: controller.isSpeaker.value,
                      onTap: () => controller.toggleSpeaker(),
                    )),
                    Obx(() => _CallActionButton(
                      icon: controller.isMuted.value ? Icons.mic_off : Icons.mic,
                      label: 'Mute',
                      isActive: controller.isMuted.value,
                      onTap: () => controller.toggleMute(),
                    )),
                  ],
                ),
              ),

              /// End Call Button
              Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: const Color(0xFFE74C3C),
                      child: IconButton(
                        icon: const Icon(Icons.call_end, color: Colors.white, size: 30),
                        onPressed: () {
                          controller.endCall();
                          // Get.back(); // Using Get back instead of Navigator
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text("End Call", style: TextStyle(color: Colors.white54))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dynamic Small Action Button
class _CallActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _CallActionButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: isActive ? Colors.white : const Color(0xFF2A3042),
            child: Icon(
                icon,
                color: isActive ? const Color(0xFF1E2433) : Colors.white
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white70,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}