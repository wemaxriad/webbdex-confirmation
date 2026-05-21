import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/direct_call_controller.dart';

class DirectCallScreenPage extends StatelessWidget {
  const DirectCallScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DirectCallController>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF111827), Color(0xFF030712)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 34, left: 20, right: 20),
                child: Column(
                  children: [
                    Obx(
                      () => Text(
                        controller.callStatus.value,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () => Text(
                        controller.formattedTime,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => Text(
                        controller.fullNumber,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF22C55E).withValues(alpha: .16),
                  border: Border.all(color: const Color(0xFF22C55E), width: 2),
                ),
                child: const Icon(
                  Icons.dialpad_rounded,
                  color: Color(0xFF22C55E),
                  size: 78,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 58),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(
                      () => _CallActionButton(
                        icon: controller.isSpeaker.value
                            ? Icons.volume_up
                            : Icons.volume_down,
                        label: 'Speaker',
                        isActive: controller.isSpeaker.value,
                        onTap: controller.toggleSpeaker,
                      ),
                    ),
                    Obx(
                      () => _CallActionButton(
                        icon: controller.isMuted.value ? Icons.mic_off : Icons.mic,
                        label: 'Mute',
                        isActive: controller.isMuted.value,
                        onTap: controller.toggleMute,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: const Color(0xFFEF4444),
                      child: IconButton(
                        icon: const Icon(
                          Icons.call_end,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: controller.endCall,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'End Call',
                      style: TextStyle(color: Colors.white54),
                    ),
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
            backgroundColor: isActive ? Colors.white : const Color(0xFF1F2937),
            child: Icon(
              icon,
              color: isActive ? const Color(0xFF111827) : Colors.white,
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
