import 'package:flutter/material.dart';

class Textformfield extends StatefulWidget {
  final String label;
  final String? hint;
  final bool isPass;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const Textformfield({
    Key? key,
    required this.label,
    this.hint,
    this.isPass = false,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  State<Textformfield> createState() => _TextformfieldState();
}

class _TextformfieldState extends State<Textformfield> {
  bool _obscureText = true;
  // final String label;
  // final String? hint;
  // final bool isPass;
  // final TextEditingController controller;
  // final String? Function(String?)? validator;
  // final TextInputType keyboardType;
  // bool _isPass = true;

  // const Textformfield({
  //   Key? key,
  //   required this.label,
  //   this.hint,
  //   this.isPass = false,
  //   required this.controller,
  //   this.validator,
  //   this.keyboardType = TextInputType.text,
  // }) : super(key: key);

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPass ? _obscureText : widget.isPass,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        border: OutlineInputBorder(),
        suffixIcon: widget.isPass
            ? IconButton(
                icon: Icon(
                  widget.isPass ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  _togglePasswordVisibility();
                })
            : null,
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(color: Colors.blue),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      style: TextStyle(color: Colors.black),
    );
  }
}

// class Textformfield extends StatelessWidget {
//   final String label;
//   final String? hint;
//   final bool isPass;
//   final TextEditingController controller;
//   final String? Function(String?)? validator;
//   final TextInputType keyboardType;

//   const Textformfield({
//     Key? key,
//     required this.label,
//     this.hint,
//     this.isPass = false,
//     required this.controller,
//     this.validator,
//     this.keyboardType = TextInputType.text,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       obscureText: isPass,
//       validator: validator,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hint,
//         border: OutlineInputBorder(),
//         suffixIcon: IconButton(
//             icon: Icon(
//               isPass ? Icons.visibility : Icons.visibility_off,
//             ),
//             onPressed: () {
//               setState(() {
//                 _obscureText = !_obscureText; // Toggle the visibility
//               });
//             }),
//         filled: true,
//         fillColor: Colors.white,
//         labelStyle: TextStyle(color: Colors.blue),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//         ),
//       ),
//       style: TextStyle(color: Colors.black),
//     );
//   }
// }
