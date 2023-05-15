class Address {
  final String? id;
  final String? name;
  final int? pinCode;
  final String? permanentAddress;
  final String? state;
  final String? city;
  final bool? defaultAddressBool;

  Address(
    this.name,
    this.pinCode,
    this.permanentAddress,
    this.state,
    this.defaultAddressBool,
    this.city, {
    this.id,
    
  });
}
