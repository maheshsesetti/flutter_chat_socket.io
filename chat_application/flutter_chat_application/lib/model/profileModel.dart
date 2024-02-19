class ProfileModel {
  final String userId;
  final String name;
  final String status;
  final String phNumber;
  final String profilePic;
  ProfileModel(
      {required this.userId,required this.name, required this.status, required this.phNumber,required this.profilePic});

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
      userId: json["userId"],
      name: json["name"], status: json["status"], phNumber: json["phNumber"],profilePic: json["profilePic"]);
  Map<String, dynamic> toJson() => {
         "userId" : userId,
        "name": name,
        "status": status,
        "phNumber": phNumber,
        "profilePic": profilePic
      };
}
