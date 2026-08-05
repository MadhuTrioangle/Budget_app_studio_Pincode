class PincodeResponse {
  final String status;
  final List<PostOffice> postOffices;

  PincodeResponse({required this.status, required this.postOffices});

  factory PincodeResponse.fromJson(Map<String, dynamic> json) {
    var list = json['PostOffice'] as List? ?? [];
    List<PostOffice> offices = list.map((i) => PostOffice.fromJson(i)).toList();
    return PincodeResponse(
      status: json['Status'] ?? '',
      postOffices: offices,
    );
  }
}

class PostOffice {
  final String name;
  final String district;
  final String state;

  PostOffice({required this.name, required this.district, required this.state});

  factory PostOffice.fromJson(Map<String, dynamic> json) {
    return PostOffice(
      name: json['Name'] ?? '',
      district: json['District'] ?? '',
      state: json['State'] ?? '',
    );
  }
}