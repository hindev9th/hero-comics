class UserModal {
  String? name;
  String? avatar;
  String? username;
  String? token;

  UserModal({this.name, this.avatar, this.username, this.token});

  UserModal.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    avatar = json['avatar'];
    username = json['username'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['avatar'] = avatar;
    data['username'] = username;
    data['token'] = token;
    return data;
  }
}
