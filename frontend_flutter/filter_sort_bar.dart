import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/providers/task_provider.dart';

class FilterSortBar extends StatelessWidget {
  const FilterSortBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Filter buttons
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Consumer<TaskProvider>(
                    builder: (context, taskProvider, _) {
                      return Row(
                        children: [
                          _FilterButton(
                            label: 'All',
                            isSelected: taskProvider.filterStatus == 'all',
                            onPressed: () =>
                                taskProvider.setFilterStatus('all'),
                          ),
                          const SizedBox(width: 8),
                          _FilterButton(
                            label: 'Completed',
                            isSelected: taskProvider.filterStatus == 'completed',
                            onPressed: () =>
                                taskProvider.setFilterStatus('completed'),
                          ),
                          const SizedBox(width: 8),
                          _FilterButton(
                            label: 'Pending',
                            isSelected: taskProvider.filterStatus == 'pending',
                            onPressed: () =>
                                taskProvider.setFilterStatus('pending'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Sort dropdown
          Consumer<TaskProvider>(
            builder: (context, taskProvider, _) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: const SizedBox(),
                  value: taskProvider.sortBy,
                  onChanged: (value) {
                    if (value != null) {
                      taskProvider.setSortBy(value);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'date',
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Sort by Due Date'),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'priority',
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Sort by Priority'),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'name',
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Sort by Name'),
                      ),
                    ),
                  ],
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _FilterButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[100] : Colors.grey[100],
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blue[700] : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
