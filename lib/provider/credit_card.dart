import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/credit_card_model.dart';

class CreditCardProvider with ChangeNotifier {
  List<CreditCardModel> _savedCards = [];

  List<CreditCardModel> get savedCards => _savedCards;
  CreditCardProvider() {
    loadSavedCards();
  }
  Future<void> loadSavedCards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedCardsJson = prefs.getString('savedCards');
    if (savedCardsJson != null) {
      List<dynamic> decodedCards = jsonDecode(savedCardsJson);
      _savedCards = decodedCards
          .map((cardMap) => CreditCardModel.fromMap(Map<String, String>.from(cardMap)))
          .toList();
      notifyListeners();
    }
  }

  Future<void> saveCards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> cardsAsMaps = _savedCards.map((card) => card.toMap()).toList();
    await prefs.setString('savedCards', jsonEncode(cardsAsMaps));
  }

  bool validateCard(CreditCardModel card, List<String> bannedCountries) {
    if (bannedCountries.contains(card.issuingCountry)) {
      return false;
    }
    if (_savedCards.any((savedCard) => savedCard.cardNumber == card.cardNumber)) {
      return false;
    }
    return true;
  }

  Future<void> saveCard(CreditCardModel card) async {
    _savedCards.add(card);
    await saveCards();
    notifyListeners();
  }
}
