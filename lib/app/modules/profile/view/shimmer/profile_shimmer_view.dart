import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileShimmerView extends StatelessWidget {
  const ProfileShimmerView({super.key});

  Widget _shimmerBox({
    double height = 16,
    double width = double.infinity,
    BorderRadius borderRadius =
    const BorderRadius.all(Radius.circular(8)),
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 20),

          /// Profile Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _shimmerBox(height: 60, width: 60,
                      borderRadius: BorderRadius.circular(30)),
                  const SizedBox(height: 10),
                  _shimmerBox(width: 120),
                  const Divider(height: 30),
                  _shimmerBox(),
                  const SizedBox(height: 10),
                  _shimmerBox(),
                  const SizedBox(height: 10),
                  _shimmerBox(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// Menu Shimmers
          ...List.generate(
            4,
                (_) => Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: _shimmerBox(height: 50),
            ),
          ),
        ],
      ),
    );
  }
}
