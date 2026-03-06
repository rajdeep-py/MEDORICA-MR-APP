import 'package:flutter_riverpod/legacy.dart';
import '../models/month_plan.dart';

class MonthPlanNotifier extends StateNotifier<List<MonthPlan>> {
  MonthPlanNotifier() : super([]) {
    _loadMonthPlans();
  }

  // Load month plans - mock data for now
  void _loadMonthPlans() {
    final now = DateTime.now();
    state = [
      MonthPlan(
        id: '1',
        date: DateTime(now.year, now.month, 5),
        activities: [
          PlanActivity(
            id: 'a1',
            type: PlanActivityType.doctorVisit,
            title: 'Visit Dr. Smith',
            description: 'Discuss new product line',
            time: '10:00 AM',
            location: 'City Hospital',
            contactId: '1',
          ),
          PlanActivity(
            id: 'a2',
            type: PlanActivityType.chemistVisit,
            title: 'Visit MedPlus Pharmacy',
            description: 'Check inventory and promote new products',
            time: '2:30 PM',
            location: 'Main Street',
            contactId: '1',
          ),
        ],
        notes: 'Focus on cardiology products',
      ),
      MonthPlan(
        id: '2',
        date: DateTime(now.year, now.month, 10),
        activities: [
          PlanActivity(
            id: 'a3',
            type: PlanActivityType.meeting,
            title: 'Team Meeting',
            description: 'Monthly review and planning',
            time: '11:00 AM',
            location: 'Regional Office',
          ),
        ],
        notes: 'Prepare sales report',
      ),
      MonthPlan(
        id: '3',
        date: DateTime(now.year, now.month, 15),
        activities: [
          PlanActivity(
            id: 'a4',
            type: PlanActivityType.distributorVisit,
            title: 'Meet ABC Distributors',
            description: 'Discuss quarterly targets',
            time: '9:30 AM',
            location: 'Warehouse District',
            contactId: '1',
          ),
          PlanActivity(
            id: 'a5',
            type: PlanActivityType.doctorVisit,
            title: 'Visit Dr. Johnson',
            description: 'Follow-up on previous meeting',
            time: '3:00 PM',
            location: 'Community Clinic',
            contactId: '2',
            isCompleted: true,
          ),
        ],
      ),
      MonthPlan(
        id: '4',
        date: DateTime(now.year, now.month, 20),
        activities: [
          PlanActivity(
            id: 'a6',
            type: PlanActivityType.doctorVisit,
            title: 'Visit Dr. Kumar',
            description: 'Product demonstration',
            time: '1:00 PM',
            location: 'Metro Hospital',
            contactId: '3',
          ),
        ],
        notes: 'Bring product samples',
      ),
      MonthPlan(
        id: '5',
        date: DateTime(now.year, now.month, 25),
        activities: [
          PlanActivity(
            id: 'a7',
            type: PlanActivityType.chemistVisit,
            title: 'Apollo Pharmacy Visit',
            description: 'Monthly stock review',
            time: '10:30 AM',
            location: 'Downtown',
            contactId: '2',
          ),
          PlanActivity(
            id: 'a8',
            type: PlanActivityType.chemistVisit,
            title: 'Wellness Pharmacy',
            description: 'Introduce new products',
            time: '2:00 PM',
            location: 'East Side',
            contactId: '3',
          ),
          PlanActivity(
            id: 'a9',
            type: PlanActivityType.other,
            title: 'Prepare monthly report',
            description: 'Compile visit summaries',
            time: '5:00 PM',
          ),
        ],
      ),
    ];
  }

  // Add a new plan
  void addPlan(MonthPlan plan) {
    state = [...state, plan.copyWith(id: DateTime.now().toString())];
  }

  // Update a plan
  void updatePlan(MonthPlan updatedPlan) {
    state = [
      for (final plan in state)
        if (plan.id == updatedPlan.id) updatedPlan else plan,
    ];
  }

  // Delete a plan
  void deletePlan(String id) {
    state = [
      for (final plan in state)
        if (plan.id != id) plan
    ];
  }

  // Get plan by date
  MonthPlan? getPlanByDate(DateTime date) {
    try {
      return state.firstWhere(
        (plan) =>
            plan.date.year == date.year &&
            plan.date.month == date.month &&
            plan.date.day == date.day,
      );
    } catch (e) {
      return null;
    }
  }

  // Get plans for a specific month
  List<MonthPlan> getPlansForMonth(DateTime month) {
    return state
        .where((plan) =>
            plan.date.year == month.year && plan.date.month == month.month)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  // Get all dates that have plans in a specific month
  List<DateTime> getDatesWithPlans(DateTime month) {
    return getPlansForMonth(month).map((plan) => plan.date).toList();
  }

  // Toggle activity completion
  void toggleActivityCompletion(String planId, String activityId) {
    state = [
      for (final plan in state)
        if (plan.id == planId)
          plan.copyWith(
            activities: [
              for (final activity in plan.activities)
                if (activity.id == activityId)
                  activity.copyWith(isCompleted: !activity.isCompleted)
                else
                  activity,
            ],
          )
        else
          plan,
    ];
  }

  // Add activity to plan
  void addActivityToPlan(String planId, PlanActivity activity) {
    state = [
      for (final plan in state)
        if (plan.id == planId)
          plan.copyWith(
            activities: [...plan.activities, activity],
          )
        else
          plan,
    ];
  }

  // Remove activity from plan
  void removeActivityFromPlan(String planId, String activityId) {
    state = [
      for (final plan in state)
        if (plan.id == planId)
          plan.copyWith(
            activities: plan.activities
                .where((a) => a.id != activityId)
                .toList(),
          )
        else
          plan,
    ];
  }
}
