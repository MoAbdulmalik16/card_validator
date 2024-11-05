
class CreditCardModel {
  String cardNumber;
  String cardType;
  String cvv;
  String issuingCountry;

  CreditCardModel({
    required this.cardNumber,
    required this.cardType,
    required this.cvv,
    required this.issuingCountry,
  });

  static String inferCardType(String number) {
    if (number.isEmpty || number.length < 13) {
      return 'Invalid';
    }

    if (number.startsWith('4')) {
      return 'Visa';
    } else if (number.startsWith('5')) {
      return 'MasterCard';
    } else if (number.startsWith('34') || number.startsWith('37')) {
      return 'American Express';
    } else if (number.startsWith('6011') ||
        number.startsWith('65') ||
        (number.startsWith('64') && number.length >= 16 && int.parse(number.substring(0, 3)) >= 644 && int.parse(number.substring(0, 3)) <= 649)) {
      return 'Discover';
    } else if (number.startsWith('35')) {
      return 'JCB';
    } else if ((number.startsWith('36') || number.startsWith('38')) && number.length == 14) {
      return 'Diners Club';
    }
    return 'Unknown';
  }

  Map<String, String> toMap() {
    return {
      'cardNumber': cardNumber,
      'cvv': cvv,
      'issuingCountry': issuingCountry,
      'cardType': cardType,
    };
  }

  factory CreditCardModel.fromMap(Map<String, String> map) {
    return CreditCardModel(
      cardNumber: map['cardNumber'] ?? '',
      cardType: map['cardType'] ?? 'Unknown',
      cvv: map['cvv'] ?? '',
      issuingCountry: map['issuingCountry'] ?? '',
    );
  }
}
