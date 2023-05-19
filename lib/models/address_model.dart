class Address {
  final String? id;
  final String? name;
  final int? pinCode;
  final String? permanentAddress;
  final String? state;
  final String? city;
  final bool? defaultAddressBool;

  Address.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          name: json['name']! as String,
          pinCode: json['pin code']! as int,
          permanentAddress: json['permanent address']! as String,
          state: json['state']! as String,
          city: json['city']! as String,
          defaultAddressBool: json['defaultAddressBool']! as bool,
        );

  Address({
    this.name,
    this.pinCode,
    this.permanentAddress,
    this.state,
    this.defaultAddressBool,
    this.city,
    this.id,
  });
}
