class AvailabilityAvailability {
  Time time;
  List<int> days;
  String id;

  AvailabilityAvailability({required this.time, required this.days, required this.id});

  factory AvailabilityAvailability.fromJson(Map<String, dynamic> json) {
    return AvailabilityAvailability(
      time: Time.fromJson(json['time']),
      days: List<int>.from(json['days']),
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time.toJson(),
      'days': days,
      '_id': id,
    };
  }
}

class Time {
  int min;
  int max;

  Time({required this.min, required this.max});

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      min: json['min'] ?? 0,
      max: json['max'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
    };
  }
}
