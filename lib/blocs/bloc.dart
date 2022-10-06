abstract class Bloc {
  Bloc();

  connect(Map<String, dynamic> map, String function);

  dispose();

  get getSink;

  get getStream;
}
