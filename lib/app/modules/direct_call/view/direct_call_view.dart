import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../globalController/global_controller.dart';
import '../controller/direct_call_controller.dart';

class DirectCallView extends StatelessWidget {
  const DirectCallView({super.key});

  static const Color _primary = Color(0xffFF3B30);
  static const Color _dark = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<DirectCallController>()
        ? Get.find<DirectCallController>()
        : Get.put(DirectCallController());
    final globalController = Get.find<GlobalController>();

    return Container(
      color: const Color(0xFFF5F5F5),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeaderCard(controller: controller, globalController: globalController),
              const SizedBox(height: 10),
              _DirectCallTabs(
                controller: controller,
                globalController: globalController,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(
                  () => controller.selectedTab.value == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _NumberCard(controller: controller),
                            const SizedBox(height: 10),
                            Expanded(
                              child: SingleChildScrollView(
                                physics: const ClampingScrollPhysics(),
                                child: _DialPad(controller: controller),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _CallNowButton(
                              controller: controller,
                              globalController: globalController,
                            ),
                          ],
                        )
                      : _DirectCallLogsView(
                          controller: controller,
                          globalController: globalController,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final DirectCallController controller;
  final GlobalController globalController;

  const _HeaderCard({
    required this.controller,
    required this.globalController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xffFF3B30), Color(0xFFEF4444)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: DirectCallView._primary.withValues(alpha: .22),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.dialpad_rounded, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  globalController.t('WebbyFirm Direct Call'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    controller.pricePerMinute.value == null
                        ? globalController.t('Call any customer number')
                        : '${globalController.t('Rate')}: ${controller.pricePerMinute.value!.toStringAsFixed(4)} / ${globalController.t('min')}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectCallTabs extends StatelessWidget {
  final DirectCallController controller;
  final GlobalController globalController;

  const _DirectCallTabs({
    required this.controller,
    required this.globalController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .035),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          children: [
            _TabButton(
              title: globalController.t('Direct Call'),
              icon: Icons.dialpad_rounded,
              isActive: controller.selectedTab.value == 0,
              onTap: () => controller.switchTab(0),
            ),
            _TabButton(
              title: globalController.t('Direct Call Logs'),
              icon: Icons.history_rounded,
              isActive: controller.selectedTab.value == 1,
              onTap: () => controller.switchTab(1),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: isActive ? DirectCallView._primary : Colors.transparent,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: isActive ? Colors.white : Colors.grey.shade700,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey.shade700,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumberCard extends StatelessWidget {
  final DirectCallController controller;

  const _NumberCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Country Code',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F0),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Obx(
              () => DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.selectedCountryCode.value,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: DirectCallView._primary,
                  ),
                  items: controller.countryCodes
                      .map(
                        (country) => DropdownMenuItem<String>(
                          value: country['code'],
                          child: Text('${country['label']} ${country['code']}'),
                        ),
                      )
                      .toList(),
                  onChanged: controller.setCountryCode,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Phone Number',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Obx(
            () => Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(
                controller.phoneNumber.value.isEmpty
                    ? 'Enter phone number'
                    : controller.fullNumber,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: controller.phoneNumber.value.isEmpty
                      ? Colors.grey
                      : DirectCallView._dark,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CallNowButton extends StatelessWidget {
  final DirectCallController controller;
  final GlobalController globalController;

  const _CallNowButton({
    required this.controller,
    required this.globalController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ElevatedButton.icon(
        onPressed: controller.phoneNumber.value.trim().isEmpty
            ? null
            : controller.makeDirectCall,
        icon: const Icon(Icons.call, color: Colors.white),
        label: Text(
          globalController.t('Call Now'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF16A34A),
          disabledBackgroundColor: Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

class _DirectCallLogsView extends StatelessWidget {
  final DirectCallController controller;
  final GlobalController globalController;

  const _DirectCallLogsView({
    required this.controller,
    required this.globalController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLogsLoading.value && controller.directCallLogs.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.directCallLogs.isEmpty) {
        return RefreshIndicator(
          onRefresh: () => controller.getDirectCallLogs(reset: true),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 80),
              Icon(Icons.history_rounded, size: 54, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  globalController.t('No direct call logs found'),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.getDirectCallLogs(reset: true),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: controller.directCallLogs.length +
              (controller.isMoreLogsLoading.value ? 1 : 0),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            if (index >= controller.directCallLogs.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (index == controller.directCallLogs.length - 1) {
              controller.getDirectCallLogs();
            }

            return _DirectCallLogCard(
              log: controller.directCallLogs[index],
              controller: controller,
              globalController: globalController,
            );
          },
        ),
      );
    });
  }
}

class _DirectCallLogCard extends StatelessWidget {
  final Map<String, dynamic> log;
  final DirectCallController controller;
  final GlobalController globalController;

  const _DirectCallLogCard({
    required this.log,
    required this.controller,
    required this.globalController,
  });

  @override
  Widget build(BuildContext context) {
    final recordingUrl = log['recording_url']?.toString();
    final totalCharge = double.tryParse(log['total_charge']?.toString() ?? '') ?? 0;
    final rate = double.tryParse(log['rate_per_minute']?.toString() ?? '') ?? 0;
    final before =
        double.tryParse(log['wallet_balance_before']?.toString() ?? '') ?? 0;
    final after =
        double.tryParse(log['wallet_balance_after']?.toString() ?? '') ?? 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.call, color: DirectCallView._primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log['to_number']?.toString() ?? '-',
                      style: const TextStyle(
                        color: DirectCallView._dark,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      log['created_at']?.toString() ?? '',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '-${totalCharge.toStringAsFixed(4)}',
                  style: const TextStyle(
                    color: Color(0xFFDC2626),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _LogPill(
                label: globalController.t('Duration'),
                value: controller.formatDuration(log['duration_seconds']),
              ),
              _LogPill(
                label: globalController.t('Billable'),
                value: '${log['billable_minutes'] ?? 0} ${globalController.t('min')}',
              ),
              _LogPill(
                label: globalController.t('Rate'),
                value: '${rate.toStringAsFixed(4)} / ${globalController.t('min')}',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${globalController.t('Wallet')}: ${before.toStringAsFixed(4)} → ${after.toStringAsFixed(4)}',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (recordingUrl != null && recordingUrl.isNotEmpty)
                TextButton.icon(
                  onPressed: () => launchUrl(
                    Uri.parse(recordingUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                  icon: const Icon(Icons.play_circle_outline, size: 18),
                  label: Text(globalController.t('Recording')),
                  style: TextButton.styleFrom(
                    foregroundColor: DirectCallView._primary,
                    padding: EdgeInsets.zero,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LogPill extends StatelessWidget {
  final String label;
  final String value;

  const _LogPill({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: DirectCallView._dark,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _DialPad extends StatelessWidget {
  final DirectCallController controller;

  const _DialPad({required this.controller});

  @override
  Widget build(BuildContext context) {
    final keys = [
      ['1', ''],
      ['2', 'ABC'],
      ['3', 'DEF'],
      ['4', 'GHI'],
      ['5', 'JKL'],
      ['6', 'MNO'],
      ['7', 'PQRS'],
      ['8', 'TUV'],
      ['9', 'WXYZ'],
      ['*', ''],
      ['0', '+'],
      ['#', ''],
    ];

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: keys.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.72,
          ),
          itemBuilder: (context, index) {
            final key = keys[index];
            return _DialKey(
              digit: key[0],
              letters: key[1],
              onTap: () => controller.addDigit(key[0]),
              onLongPress: key[0] == '0' ? () => controller.addDigit('+') : null,
            );
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: controller.clearNumber,
                icon: const Icon(Icons.clear, color: Colors.grey),
                label: const Text('Clear', style: TextStyle(color: Colors.grey)),
              ),
            ),
            Expanded(
              child: TextButton.icon(
                onPressed: controller.backspace,
                icon: const Icon(Icons.backspace_outlined, color: DirectCallView._dark),
                label: const Text(
                  'Delete',
                  style: TextStyle(color: DirectCallView._dark),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DialKey extends StatelessWidget {
  final String digit;
  final String letters;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _DialKey({
    required this.digit,
    required this.letters,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .035),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                digit,
                style: const TextStyle(
                  color: DirectCallView._dark,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (letters.isNotEmpty)
                Text(
                  letters,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
