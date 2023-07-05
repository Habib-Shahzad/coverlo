class Insurance {
  final String? transactionNumber;
  final String? policyNo;
  final String? paymentGateway;
  final String? transactionDateTime;
  final String? transactionID;

  Insurance({
    required this.transactionNumber,
    required this.policyNo,
    required this.paymentGateway,
    required this.transactionDateTime,
    required this.transactionID,
  });
  factory Insurance.fromJson(Map<String, dynamic> json) {
    return Insurance(
      transactionNumber: json['TranscationNumber'],
      policyNo: json['PolicyNo'],
      paymentGateway: json['PaymentGateway'],
      transactionDateTime: json['TranscationDateTime'],
      transactionID: json['TranscationID'],
    );
  }

  @override
  String toString() {
    return 'Transaction: \n'
        'Transaction Number: $transactionNumber\n'
        'Policy Number: $policyNo\n'
        'Payment Gateway: $paymentGateway\n'
        'Transaction Date Time: $transactionDateTime\n'
        'Transaction ID: $transactionID';
  }
}
