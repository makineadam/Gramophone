class PostModel {
  final String sender;
  final String senderId;
  String imgProfile = 'assets/images/berk.png';
  String? picture;
  final String name;
  List<String>? hashtags;
  String like = '0';
  String comment = '0';
  String share = '0';
  String audio = '';

  PostModel({
    required this.sender,
    required this.senderId,
    required this.imgProfile,
    required this.picture,
    required this.name,
    required this.hashtags,
    required this.like,
    required this.comment,
    required this.share,
    required this.audio,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        sender: json['sender'].split('@')[0],
        senderId: json['senderId'],
        imgProfile: 'assets/images/berk.png',
        picture: null,
        name: json['name'],
        hashtags: null, //List<String>.from(json["hashtag"].map((x) => x)),
        like: '0',
        comment: '0',
        share: '0',
        audio: json['audio'],
      );

  Map<String, dynamic> toJson() => {
        'sender': sender,
        'senderId': senderId,
        'imgProfile': imgProfile,
        'picture': picture,
        'name': name,
        'hashtag': hashtags,
        'like': like,
        'comment': comment,
        'share': share,
        'audio': audio,
      };
}
