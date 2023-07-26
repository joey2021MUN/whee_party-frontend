enum PaymentStatus {
  fullyPaid(1, 'Fully Paid'),
  partiallyPaid(2, 'Partially Paid'),
  notPaid(3, 'Not Paid'),
  packageNotSelected(4, 'Package Not Selected');

  final int rawValue;
  final String description;

  const PaymentStatus(this.rawValue, this.description);

  static PaymentStatus fromRawValue(int rawValue) {
    return PaymentStatus.values.firstWhere((e) => e.rawValue == rawValue);
  }
}
