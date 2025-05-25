class UserGetModel {
  UserGetModel({
    required this.success,
    required this.message,
    required this.data,
    required this.statusCode,
  });

  final bool? success;
  final String? message;
  final Data? data;
  final int? statusCode;

  factory UserGetModel.fromJson(Map<String, dynamic> json) {
    return UserGetModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
      statusCode: json["statusCode"],
    );
  }
}

class Data {
  Data({
    required this.lessonId,
    required this.lessonName,
    required this.lessonDescription,
    required this.learnFormat,
    required this.topicOutcome,
    required this.backgroundAssetUrl,
    required this.topics,
  });

  final String? lessonId;
  final String? lessonName;
  final String? lessonDescription;
  final String? learnFormat;
  final List<String> topicOutcome;
  final String? backgroundAssetUrl;
  final List<Topic> topics;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      lessonId: json["lessonId"],
      lessonName: json["lessonName"],
      lessonDescription: json["lessonDescription"],
      learnFormat: json["learnFormat"],
      topicOutcome:
          json["topicOutcome"] == null
              ? []
              : List<String>.from(json["topicOutcome"]!.map((x) => x)),
      backgroundAssetUrl: json["backgroundAssetUrl"],
      topics:
          json["topics"] == null
              ? []
              : List<Topic>.from(json["topics"]!.map((x) => Topic.fromJson(x))),
    );
  }
}

class Topic {
  Topic({
    required this.topicId,
    required this.topicName,
    required this.scriptTags,
  });

  final String? topicId;
  final String? topicName;
  final List<ScriptTag> scriptTags;

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      topicId: json["topicId"],
      topicName: json["topicName"],
      scriptTags:
          json["scriptTags"] == null
              ? []
              : List<ScriptTag>.from(
                json["scriptTags"]!.map((x) => ScriptTag.fromJson(x)),
              ),
    );
  }
}

class ScriptTag {
  ScriptTag({
    required this.id,
    required this.format,
    required this.gameType,
    required this.gameIntroAudio,
    required this.taskAudioCapitalLetter,
    required this.taskAudioSmallLetter,
    required this.correctCapitalAudios,
    required this.correctSmallAudios,
    required this.superstarAudio,
    required this.tapWrongAudio,
    required this.roundPrompts,
    required this.finishGameAudio,
    required this.cardRewardRive,
    required this.finalCelebrationRive,
    required this.sampleWords,
    required this.buttonText,
  });

  final int? id;
  final String? format;
  final String? gameType;
  final String? gameIntroAudio;
  final List<String> taskAudioCapitalLetter;
  final List<String> taskAudioSmallLetter;
  final List<String> correctCapitalAudios;
  final List<String> correctSmallAudios;
  final String? superstarAudio;
  final List<String> tapWrongAudio;
  final List<String> roundPrompts;
  final String? finishGameAudio;
  final String? cardRewardRive;
  final String? finalCelebrationRive;
  final List<String> sampleWords;
  final String? buttonText;

  factory ScriptTag.fromJson(Map<String, dynamic> json) {
    return ScriptTag(
      id: json["id"],
      format: json["format"],
      gameType: json["gameType"],
      gameIntroAudio: json["gameIntroAudio"],
      taskAudioCapitalLetter:
          json["taskAudioCapitalLetter"] == null
              ? []
              : List<String>.from(
                json["taskAudioCapitalLetter"]!.map((x) => x),
              ),
      taskAudioSmallLetter:
          json["taskAudioSmallLetter"] == null
              ? []
              : List<String>.from(json["taskAudioSmallLetter"]!.map((x) => x)),
      correctCapitalAudios:
          json["correctCapitalAudios"] == null
              ? []
              : List<String>.from(json["correctCapitalAudios"]!.map((x) => x)),
      correctSmallAudios:
          json["correctSmallAudios"] == null
              ? []
              : List<String>.from(json["correctSmallAudios"]!.map((x) => x)),
      superstarAudio: json["superstarAudio"],
      tapWrongAudio:
          json["tapWrongAudio"] == null
              ? []
              : List<String>.from(json["tapWrongAudio"]!.map((x) => x)),
      roundPrompts:
          json["roundPrompts"] == null
              ? []
              : List<String>.from(json["roundPrompts"]!.map((x) => x)),
      finishGameAudio: json["finishGameAudio"],
      cardRewardRive: json["cardRewardRive"],
      finalCelebrationRive: json["finalCelebrationRive"],
      sampleWords:
          json["sampleWords"] == null
              ? []
              : List<String>.from(json["sampleWords"]!.map((x) => x)),
      buttonText: json["buttonText"],
    );
  }
}
