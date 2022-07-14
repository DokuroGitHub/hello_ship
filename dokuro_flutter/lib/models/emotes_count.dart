class EmoteValue {
  String code;
  int value;
  EmoteValue({
    this.code = '',
    this.value = 0,
  });
}

// EmotesCount
class EmotesCount {
  late int like;
  late int love;
  late int care;
  late int haha;
  late int wow;
  late int sad;
  late int angry;

  EmotesCount({
    this.like = 0,
    this.love = 0,
    this.care = 0,
    this.haha = 0,
    this.wow = 0,
    this.sad = 0,
    this.angry = 0,
  });

  factory EmotesCount.fromJson(Map<String, dynamic> json) => EmotesCount(
        like: json['like'] ?? 0,
        love: json['love'] ?? 0,
        care: json['care'] ?? 0,
        haha: json['haha'] ?? 0,
        wow: json['wow'] ?? 0,
        sad: json['sad'] ?? 0,
        angry: json['angry'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'EmotesCount',
        'like': like,
        'love': love,
        'care': care,
        'haha': haha,
        'wow': wow,
        'sad': sad,
        'angry': angry,
      };

  @override
  String toString() => toJson().toString();
}

EmotesCount? convertMapToEmotesCount(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return EmotesCount.fromJson(json);
}