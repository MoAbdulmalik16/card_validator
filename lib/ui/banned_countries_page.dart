import 'package:card_validation/provider/banned_countries.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BannedCountriesPage extends StatelessWidget {
  final TextEditingController _countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bannedCountriesProvider = Provider.of<BannedCountriesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Banned Countries'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _countryController,
              decoration: InputDecoration(labelText: 'Enter country name'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final country = _countryController.text.trim();
                if (country.isNotEmpty) {
                  bannedCountriesProvider.addCountry(country);
                  _countryController.clear();
                }
              },
              child: Text('Add Country'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: bannedCountriesProvider.bannedCountries.length,
                itemBuilder: (context, index) {
                  final country = bannedCountriesProvider.bannedCountries[index];
                  return ListTile(
                    title: Text(country),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        bannedCountriesProvider.removeCountry(country);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
