
import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  // TODO: Implement refresh functionality
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStreakAndProblems(),
          const SizedBox(height: 24),
          _buildLeaderboard(),
          const SizedBox(height: 24),
          _buildSubjectStats(),
        ],
      ),
    );
  }

  Widget _buildStreakAndProblems() {
    return Column(
      children: [
        const Row(
          children: [
            Text('Streak:', style: TextStyle(fontSize: 16)),
            SizedBox(width: 8),
            Icon(Icons.local_fire_department, color: Colors.orange),
            SizedBox(width: 4),
            Text('3 Days', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Problems Solved:', style: TextStyle(fontSize: 16)),
            Text('250', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildLeaderboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Leaderboard',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildLeaderboardEntry('1.', 'Alex', '250 problems', 'assets/images/alex.png'),
        const SizedBox(height: 12),
        _buildLeaderboardEntry('2.', 'Sarah', '240 problems', 'assets/images/sarah.png'),
        const SizedBox(height: 12),
        _buildLeaderboardEntry('3.', 'Michael', '230 problems', 'assets/images/michael.png'),
      ],
    );
  }

  Widget _buildLeaderboardEntry(String rank, String name, String problems, String imagePath) {
    return Row(
      children: [
        Text(rank, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 12),
        CircleAvatar(
          backgroundImage: AssetImage(imagePath),
          radius: 24,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(problems, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildSubjectStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Subject Stats',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildSubjectStatCard(
                'Math',
                'Attempted: 100, Solved: 80\nAccuracy: 80%, Time: 2h',
                Icons.show_chart,
              ),
              _buildSubjectStatCard(
                'Science',
                'Attempted: 75, Solved: 60\nAccuracy: 75%, Time: 1.5h',
                Icons.science_outlined,
              ),
              _buildSubjectStatCard(
                'History',
                'Attempted: 40, Solved: 30\nAccuracy: 75%, Time: 1h',
                Icons.history_edu_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectStatCard(String subject, String stats, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(right: 16),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const Spacer(),
            Text(subject, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(stats, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
