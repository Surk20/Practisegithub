import 'package:flutter/material.dart';

class TripLeg {
  final String modeOfTransport;
  final double distance;

  TripLeg(this.modeOfTransport, this.distance);

  double calculateEmissions() {
    // Placeholder emission factors (gCO2/km)
    switch (modeOfTransport) {
      case 'Plane':
        return distance * 0.15;
      case 'Car':
        return distance * 0.18;
      case 'Train':
        return distance * 0.04;
      case 'Bus':
        return distance * 0.08;
      default:
        return 0.0;
    }
  }
}

class Trip {
  final List<TripLeg> legs;

  Trip(this.legs);

  double getTotalEmissions() {
    double totalEmissions = 0.0;
    for (var leg in legs) {
      totalEmissions += leg.calculateEmissions();
    }
    return totalEmissions;
  }
}

class TripCalculator extends StatefulWidget {
  const TripCalculator({super.key});

  @override
  TripCalculatorState createState() => TripCalculatorState();
}

class TripCalculatorState extends State<TripCalculator> {
  final _formKey = GlobalKey<FormState>();
  String _modeOfTransport = 'Plane';
  double _distance = 0.0;
  final List<TripLeg> _tripLegs = [];

  void _addTripLeg() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _tripLegs.add(TripLeg(_modeOfTransport, _distance));
        _modeOfTransport = 'Plane';
        _distance = 0.0;
      });
    }
  }

  double _calculateTotalEmissions() {
    var trip = Trip(_tripLegs);
    return trip.getTotalEmissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Carbon Footprint Calculator'),
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _modeOfTransport,
                  items: const [
                    DropdownMenuItem(
                      value: 'Plane',
                      child: Text('Plane'),
                    ),
                    DropdownMenuItem(
                      value: 'Car',
                      child: Text('Car'),
                    ),
                    DropdownMenuItem(
                      value: 'Train',
                      child: Text('Train'),
                    ),
                    DropdownMenuItem(
                      value: 'Bus',
                      child: Text('Bus'),
                    ),
                  ],
                  onChanged: (value) => setState(() => _modeOfTransport = value!),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Distance (km)'),
                  validator: (value) {
                    if (value == null || double.tryParse(value) == null || double.parse(value) <= 0) {
                      return 'Please enter a valid distance.';
                    }
                    return null;
                  },
                  onSaved: (value) => setState(() => _distance = double.parse(value!)),
                ),
                ElevatedButton(
                  onPressed: _addTripLeg,
                  child: const Text('Add Trip Leg'),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _tripLegs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${_tripLegs[index].modeOfTransport} - ${_tripLegs[index].distance.toStringAsFixed(2)} km'),
                    );
                  },
                ),
                Text(
                  'Total Emissions: ${_calculateTotalEmissions().toStringAsFixed(2)} grams of CO2',
                  style: const TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//void main() => runApp(const TripCalculator());
