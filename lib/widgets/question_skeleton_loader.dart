import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class QuestionSkeletonLoader extends StatelessWidget {
  final String subjectName;
  
  const QuestionSkeletonLoader({
    super.key,
    required this.subjectName,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).dividerColor,
      highlightColor: Theme.of(context).focusColor.withOpacity(0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Question skeleton only
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                // Question text lines
                Container(
                  height: 20,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 20,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(4),
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