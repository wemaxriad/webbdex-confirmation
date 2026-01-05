import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/constant_colors.dart';

class DashboardShimmerView extends StatelessWidget {
  const DashboardShimmerView({super.key});


  @override
  Widget build(BuildContext context) {
    return
      Column(
        children: [
          dashboardHeaderShimmer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                statGridShimmer(),
                const SizedBox(height: 20),
                SizedBox(
                  height: 300,
                  child: recentOrdersShimmer(),
                ),
              ],
            ),
          ),
        ],
      );
  }

  Widget shimmerBox({
    double height = 16,
    double width = double.infinity,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8)),
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
        ),
      ),
    );
  }

  Widget dashboardHeaderShimmer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.only(end: 20, start: 20, bottom: 20),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shimmerBox(width: 120),
          const SizedBox(height: 6),
          shimmerBox(width: 80),
          const SizedBox(height: 10),
          shimmerBox(
            height: 56,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
    );
  }

  Widget statGridShimmer() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 3 / 2,
      children: List.generate(
        4,
            (_) => shimmerBox(
          height: 90,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget recentOrdersShimmer() {
    return ListView.separated(
      itemCount: 5,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            shimmerBox(
              height: 40,
              width: 40,
              borderRadius: BorderRadius.circular(20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerBox(width: 120),
                  const SizedBox(height: 6),
                  shimmerBox(width: 80),
                ],
              ),
            ),
            shimmerBox(height: 24, width: 60),
          ],
        ),
      ),
    );
  }
}
