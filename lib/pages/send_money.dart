import 'package:flutter/material.dart';
import 'dashboard.dart';



class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({super.key});

  @override
  _SendMoneyPageState createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedPaymentMethod;
  bool isFavorite = false;
  bool showSuccessMessage = false; // Control the success message animation

  final List<String> paymentMethods = ['Bank Transfer', 'Mobile Payment', 'Credit Card'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Money'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Recipient's Name Field
              TextFormField(
                controller: recipientController,
                decoration: const InputDecoration(
                  labelText: 'Recipient\'s Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the recipient\'s name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Amount Field
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Please enter a valid amount greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Payment Method Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(),
                ),
                value: selectedPaymentMethod,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPaymentMethod = newValue;
                  });
                },
                items: paymentMethods.map<DropdownMenuItem<String>>((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a payment method';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Favorite Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Mark as Favorite'),
                  Switch(
                    value: isFavorite,
                    onChanged: (bool value) {
                      setState(() {
                        isFavorite = value;
                      });
                    },
                    activeColor: Colors.teal,
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // Custom Send Money Button
              SendButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String recipient = recipientController.text;
                    String amount = amountController.text;
                    String paymentMethod = selectedPaymentMethod ?? 'Unknown';

                    // Optionally show a success message or perform the send action
                    setState(() {
                      showSuccessMessage = true; // Trigger success message animation
                    });

                    // Show success feedback
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Sending \$$amount to $recipient via $paymentMethod'),
                    ));
                  }
                },
                label: 'Send Money',
              ),

              const SizedBox(height: 20.0),

              // Success Message with Animation
              AnimatedOpacity(
                opacity: showSuccessMessage ? 1.0 : 0.0,
                duration: const Duration(seconds: 2),
                child: const Text(
                  'Transaction Successful!',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Send Button Widget
class SendButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const SendButton({required this.onPressed, required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      ),
      child: Text(label),
    );
  }
}

// Page Transition Example
void navigateToDashboard(BuildContext context) {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => DashboardPage(), // Define the next page
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Start from the right
        const end = Offset.zero; // End at the current position
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
  );
}

