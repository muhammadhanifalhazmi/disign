import 'package:disign/app/data/models/list_devices_model.dart';
import 'package:intl/intl.dart';

class UserInfo {
  User? user;
  Devices? device;
  // Cert? cert;

  UserInfo({this.user, this.device});

  UserInfo.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User?.fromJson(json['user']) : null;
    device = json['device'] != null ? Devices?.fromJson(json['device']) : null;
    // cert = json['cert'] != null ? Cert?.fromJson(json['cert']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user?.toJson();
    }
    if (device != null) {
      data['device'] = device?.toJson();
    }
    // if (cert != null) {
    //   data['cert'] = cert?.toJson();
    // }
    return data;
  }
}

class User {
  int? id;
  String? username;
  String? name;
  String? email;
  dynamic locationInfo;
  dynamic emailVerifiedAt;
  // String? pin;
  int? role;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.username,
      this.name,
      this.email,
      this.locationInfo,
      this.emailVerifiedAt,
      // this.pin,
      this.role,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    email = json['email'];
    locationInfo = json['location_info'];
    emailVerifiedAt = json['email_verified_at'];
    // pin = json['pin'];
    role = json['role'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['name'] = name;
    data['email'] = email;
    data['location_info'] = locationInfo;
    data['email_verified_at'] = emailVerifiedAt;
    // data['pin'] = pin;
    data['role'] = role;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Certificate {
  int? id;
  int? deviceId;
  String? publicKey;
  String? certificate;
  String? certificateChain;
  String? certificateSrl;
  int? isRevoked;
  dynamic revokedAt;
  dynamic revokedTimestamp;
  dynamic revokationDetail;
  String? validStart;
  String? validEnd;
  String? createdAt;
  String? updatedAt;
  String? expires;

  Certificate(
      {this.id,
      this.deviceId,
      this.publicKey,
      this.certificate,
      this.certificateChain,
      this.certificateSrl,
      this.isRevoked,
      this.revokedAt,
      this.revokedTimestamp,
      this.revokationDetail,
      this.validStart,
      this.validEnd,
      this.createdAt,
      this.updatedAt});

  String _convertTimestampToDate(validEnd) {
    // convert string to int
    int exp = int.parse(validEnd);

    // Convert the timestamp to milliseconds
    int milliseconds = exp * 1000;

    // Create a DateTime object from the milliseconds
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    // Define the desired date format
    DateFormat formatter = DateFormat(
        'dd/MM/yy'); // Change the format as per your requirement
        // 'yyyy-MM-dd HH:mm:ss'); // Change the format as per your requirement

    // Format the DateTime object to the desired format
    String formattedDate = formatter.format(dateTime);

    // Return the formatted date
    return formattedDate;
  }

  Certificate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deviceId = json['device_id'];
    publicKey = json['public_key'];
    certificate = json['certificate'];
    certificateChain = json['certificate_chain'];
    certificateSrl = json['certificate_srl'];
    isRevoked = json['is_revoked'];
    revokedAt = json['revoked_at'];
    revokedTimestamp = json['revoked_timestamp'];
    revokationDetail = json['revokation_detail'];
    validStart = json['valid_start'];
    validEnd = json['valid_end'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    expires = _convertTimestampToDate(json['valid_end']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['device_id'] = deviceId;
    data['public_key'] = publicKey;
    data['certificate'] = certificate;
    data['certificate_chain'] = certificateChain;
    data['certificate_srl'] = certificateSrl;
    data['is_revoked'] = isRevoked;
    data['revoked_at'] = revokedAt;
    data['revoked_timestamp'] = revokedTimestamp;
    data['revokation_detail'] = revokationDetail;
    data['valid_start'] = validStart;
    data['valid_end'] = validEnd;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['expires'] = _convertTimestampToDate(validEnd);
    return data;
  }
}
