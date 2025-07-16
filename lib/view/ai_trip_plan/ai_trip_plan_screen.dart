import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:main_project/view/ai_trip_plan/ai_trip_plan_bloc.dart';
import 'package:shimmer/shimmer.dart';

class AiTripPlanScreen extends StatefulWidget {
  const AiTripPlanScreen({super.key});

  @override
  TravelAssistantSheetState createState() => TravelAssistantSheetState();
}

class TravelAssistantSheetState extends State<AiTripPlanScreen> {
  final TextEditingController placeController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  String travelType = "Adventure"; // Default selection

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    placeController.dispose();
    budgetController.dispose();
    daysController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<AiTripPlanBloc, AiTripPlanState>(
            builder: (context, state) {
              if (state is ChatbotLoading) {
                return _buildShimmerEffect();
              } else if (state is ChatbotLoaded) {
                return _buildTripPlan(state.tripPlan);
              }
              return _buildPlaceholder();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerEffect() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "Enter details to get trip suggestions.",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildTripPlan(String tripPlan) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MarkdownBody(
            data: tripPlan,
            selectable: true,
            styleSheet:
                MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              p: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}

void showAITripBottomSheet(BuildContext context) {
  final TextEditingController placeController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  String travelType = "Adventure"; // Default selection

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Plan Your Trip",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: travelType,
              items: ["Adventure", "Relaxation", "Cultural", "Wildlife"]
                  .map((type) =>
                      DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {
                if (value != null) travelType = value;
              },
              decoration: InputDecoration(
                labelText: "Travel Type",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: placeController,
              decoration: InputDecoration(
                labelText: "Destination",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: budgetController,
              decoration: InputDecoration(
                labelText: "Budget",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: daysController,
              decoration: InputDecoration(
                labelText: "Number of Days",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final place = placeController.text.trim();
                  final budget = budgetController.text.trim();
                  final days = daysController.text.trim();

                  if (place.isEmpty || budget.isEmpty || days.isEmpty) return;

                  context
                      .read<AiTripPlanBloc>()
                      .add(GetTripPlan(travelType, place, budget, days));

                  Navigator.pop(context); // Close bottom sheet
                  placeController.clear();
                  budgetController.clear();
                  daysController.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Get Trip Plan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
