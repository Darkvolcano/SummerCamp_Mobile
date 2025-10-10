import 'package:summercamp/features/camp/domain/entities/camp.dart';

class CampModel extends Camp {
  const CampModel({
    required super.campId,
    required super.name,
    required super.description,
    required super.place,
    required super.startDate,
    required super.endDate,
    super.image,
    super.maxParticipants,
    super.minParticipants,
    required super.price,
    required super.status,
    required super.campTypeId,
  });

  factory CampModel.fromJson(Map<String, dynamic> json) {
    // Hàm tiện ích để chuyển đổi an toàn các trường String
    String safeString(dynamic value) {
      if (value == null) return '';
      // Đảm bảo mọi thứ đều là String, tránh lỗi Null->String
      return value.toString();
    }

    // Hàm tiện ích để chuyển đổi an toàn các trường số
    int safeInt(dynamic value) {
      if (value is int) return value;
      if (value is double) return value.round(); // Xử lý trường hợp 0.0 -> 0
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    // API trả về giá trị Date/DateTime dưới dạng String
    // DateTime safeDateTime(dynamic value) {
    //   if (value is DateTime) return value;
    //   if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    //   return DateTime.now();
    // }

    // Giá API trả về là double, nhưng Camp entity yêu cầu int (price)
    int safePrice(dynamic value) {
      if (value is int) return value;
      if (value is double) return value.round();
      return 0;
    }

    return CampModel(
      campId: safeInt(json['campId']),
      name: safeString(json['name']),
      description: safeString(json['description']),
      place: safeString(json['place']),

      // Xử lý các trường DateTime
      startDate: safeString(json['startDate']),
      endDate: safeString(json['endDate']),

      // Xử lý các trường có thể là NULL từ API
      image: safeString(json['image']),
      minParticipants: safeInt(json['minParticipants']),
      maxParticipants: safeInt(json['maxParticipants']),

      price: safePrice(json['price']),
      status: safeString(json['status']),
      campTypeId: safeInt(json['campTypeId']),
    );
  }

  Map<String, dynamic> toJson() => {
    'campId': campId,
    'name': name,
    'description': description,
    'place': place,
    'startDate': startDate,
    'endDate': endDate,
    'image': image,
    'maxParticipants': maxParticipants,
    'minParticipants': minParticipants,
    'price': price,
    'status': status,
    'campTypeId': campTypeId,
  };
}
