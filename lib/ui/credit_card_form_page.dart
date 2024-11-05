import 'package:card_validation/model/credit_card.dart';
import 'package:card_validation/provider/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CreditCardFormPage extends StatefulWidget {
  CreditCardFormPage({super.key});

  @override
  _CreditCardFormPageState createState() => _CreditCardFormPageState();
}

class _CreditCardFormPageState extends State<CreditCardFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  bool _isButtonEnabled = false;
  String? _duplicateCardError;

  void _checkFormValidation() {
    setState(() {
      _isButtonEnabled = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardProvider = Provider.of<CreditCardProvider>(context);
    final bannedCountriesProvider =
        Provider.of<BannedCountriesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Credit Card Validator'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/bannedCountries');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          onChanged: _checkFormValidation,
          child: Column(
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.camera_alt),
                label: Text("Scan Card"),
                onPressed: _scanCard,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  errorText: _duplicateCardError,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a card number';
                  } else if (value.length < 13) {
                    return 'Card number should be at least 13 digits';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cvvController,
                decoration: InputDecoration(labelText: 'CVV'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the CVV';
                  } else if (value.length < 3 || value.length > 4) {
                    return 'CVV should be 3 or 4 digits';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(labelText: 'Issuing Country'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the issuing country';
                  } else if (bannedCountriesProvider.bannedCountries
                      .contains(value)) {
                    return '$value is a banned country';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isButtonEnabled
                    ? () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final newCard = CreditCardModel(
                            cardNumber: _cardNumberController.text,
                            cvv: _cvvController.text,
                            issuingCountry: _countryController.text,
                            cardType: CreditCardModel.inferCardType(_cardNumberController.text),
                          );

                          if (cardProvider.validateCard(newCard,
                              bannedCountriesProvider.bannedCountries)) {
                            cardProvider.saveCard(newCard);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Card saved successfully!')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Card validation failed!')),
                            );
                          }
                        }
                      }
                    : null,
                child: Text('Validate and Save'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: cardProvider.savedCards.length,
                  itemBuilder: (context, index) {
                    final card = cardProvider.savedCards[index];
                    return ListTile(
                      title:
                          Text('Card: ${card.cardNumber} (${card.cardType})'),
                      subtitle: Text('Country: ${card.issuingCountry}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _scanCard() async {
    final cardDetails = await CreditCardScanner.scanCard();

    if (cardDetails != null && cardDetails.cardNumber != null) {
      setState(() {
        _cardNumberController.text = cardDetails.cardNumber!;
      });
      _checkFormValidation();
    }
  }
}
