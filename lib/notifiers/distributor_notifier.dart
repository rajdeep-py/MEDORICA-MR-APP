import 'package:flutter_riverpod/legacy.dart';
import '../models/distributor.dart';

class DistributorNotifier extends StateNotifier<List<Distributor>> {
  DistributorNotifier() : super([]) {
    _loadDistributors();
  }

  // Load distributors - mock data for now
  void _loadDistributors() {
    state = [
      Distributor(
        id: '1',
        name: 'MedSupply Distributors',
        phoneNumber: '+880 1700 777888',
        email: 'contact@medsupply.com',
        photo: 'https://via.placeholder.com/400x300?text=MedSupply+Distributors',
        location: '45 Industrial Area, Dhaka',
        description:
            'Leading pharmaceutical distributor with over 15 years of experience. We supply quality medicines from all major brands to pharmacies across the country.',
        minimumOrderValue: 'Rs. 50,000',
        deliveryTime: 'Same Day',
      ),
      Distributor(
        id: '2',
        name: 'PharmaCare Distribution',
        phoneNumber: '+880 1800 999000',
        email: 'info@pharmacare.com',
        photo: 'https://via.placeholder.com/400x300?text=PharmaCare+Distribution',
        location: '123 Trade Center, Chittagong',
        description:
            'Trusted distributor specializing in imported and generic medicines. Fast delivery and competitive pricing with excellent customer service.',
        minimumOrderValue: 'Rs. 75,000',
        deliveryTime: '24 Hours',
      ),
      Distributor(
        id: '3',
        name: 'Global Pharma Supply',
        phoneNumber: '+880 1900 111222',
        email: 'sales@globalpharma.com',
        photo: 'https://via.placeholder.com/400x300?text=Global+Pharma+Supply',
        location: '78 Business Hub, Dhaka',
        description:
            'International standard pharmaceutical distribution with temperature-controlled storage. We ensure quality and timely delivery of all medical supplies.',
        minimumOrderValue: 'Rs. 100,000',
        deliveryTime: '48 Hours',
      ),
    ];
  }

  // Add a new distributor
  void addDistributor(Distributor distributor) {
    state = [...state, distributor.copyWith(id: DateTime.now().toString())];
  }

  // Update a distributor
  void updateDistributor(Distributor updatedDistributor) {
    state = [
      for (final distributor in state)
        if (distributor.id == updatedDistributor.id)
          updatedDistributor
        else
          distributor,
    ];
  }

  // Delete a distributor
  void deleteDistributor(String id) {
    state = [
      for (final distributor in state)
        if (distributor.id != id) distributor
    ];
  }

  // Get a distributor by id
  Distributor? getDistributorById(String id) {
    try {
      return state.firstWhere((distributor) => distributor.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search distributors
  List<Distributor> searchDistributors(String query) {
    if (query.isEmpty) return state;
    final lowerQuery = query.toLowerCase();
    return state
        .where((distributor) =>
            distributor.name.toLowerCase().contains(lowerQuery) ||
            distributor.location.toLowerCase().contains(lowerQuery))
        .toList();
  }
}
