class Story {
  int score;
  String author;
  int id;
  int time;
  String title;
  String type;
  int descendants;
  String url;
  List<int> kids;

  Story({
    this.score,
    this.author,
    this.id,
    this.time,
    this.title,
    this.type,
    this.descendants,
    this.url,
    this.kids,
  });

  Story.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    author = json['by'];
    id = json['id'];
    time = json['time'];
    title = json['title'];
    type = json['type'];
    descendants = json['descendants'];
    url = json['url'];
    kids = json['kids']?.cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['score'] = this.score;
    data['by'] = this.author;
    data['id'] = this.id;
    data['time'] = this.time;
    data['title'] = this.title;
    data['type'] = this.type;
    data['descendants'] = this.descendants;
    data['url'] = this.url;
    data['kids'] = this.kids;
    return data;
  }
}
