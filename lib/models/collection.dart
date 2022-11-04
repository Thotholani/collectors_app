class Collection  {
  final String collection_id;
  final String date;
  final String status;
  final String address;
  final String fee;

  Collection({required this.address,required this.date, required this.status, required this.collection_id, required this.fee});

  static Collection fromJson(json) => Collection(
    collection_id: json['collection_id'],
    date: json['collection_date'],
    status: json['status'],
    address: json['address'],
    fee: json['service_fee']
  );
}