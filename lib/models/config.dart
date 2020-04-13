class Config {
  final String database;
  final List<String> order;

  Config({
    this.database,
    this.order,
  });

  factory Config.fromMap(Map<String, dynamic> data) => Config(
        database: data['database'],
        order: List.castFrom<dynamic, String>(data['order']),
      );
}
