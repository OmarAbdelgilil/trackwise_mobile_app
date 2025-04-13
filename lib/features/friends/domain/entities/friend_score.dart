class FriendScore {
  String email;
  double score;
  int steps;
  double usage;
  String name;
  bool me;
  FriendScore(
      {required this.score,
      required this.email,
      required this.name,
      required this.steps,
      required this.usage,
      this.me = false});
}
