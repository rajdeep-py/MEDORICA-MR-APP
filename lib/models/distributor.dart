class Distributor {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String photo;
  final String location;
  final String description;
  final String minimumOrderValue;
  final String deliveryTime;

  Distributor({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.photo,
    required this.location,
    required this.description,
    required this.minimumOrderValue,
    required this.deliveryTime,
  });

  // Copy with method for updates
  Distributor copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? photo,
    String? location,
    String? description,
    String? minimumOrderValue,
    String? deliveryTime,
  }) {
    return Distributor(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      photo: photo ?? this.photo,
      location: location ?? this.location,
      description: description ?? this.description,
      minimumOrderValue: minimumOrderValue ?? this.minimumOrderValue,
      deliveryTime: deliveryTime ?? this.deliveryTime,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phoneNumber': phoneNumber,
        'email': email,
        'photo': photo,
        'location': location,
        'description': description,
        'minimumOrderValue': minimumOrderValue,
        'deliveryTime': deliveryTime,
      };

  // Create from JSON
  factory Distributor.fromJson(Map<String, dynamic> json) => Distributor(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
        email: json['email'] ?? '',
        photo: json['photo'] ?? '',
        location: json['location'] ?? '',
        description: json['description'] ?? '',
        minimumOrderValue: json['minimumOrderValue'] ?? '',
        deliveryTime: json['deliveryTime'] ?? '',
      );
}
