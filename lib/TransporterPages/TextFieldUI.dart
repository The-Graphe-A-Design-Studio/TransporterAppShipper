import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:shipperapp/Models/TextField.dart';
import 'package:shipperapp/MyConstants.dart';

typedef OnDelete();

class TextFieldUI extends StatefulWidget {
  final state = _TextFieldUIState();
  final TextFieldModel textField;
  final OnDelete onDelete;

  TextFieldUI({Key key, this.textField, this.onDelete}) : super(key: key);

  @override
  _TextFieldUIState createState() => state;
}

class _TextFieldUIState extends State<TextFieldUI> {
  final fromController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      initialValue: widget.textField.place,
      onTap: () async {
        Prediction p = await PlacesAutocomplete.show(
            context: context,
            apiKey: GoogleApiKey,
            mode: Mode.overlay,
            language: "en",
            startText: widget.textField.place,
            components: [Component(Component.country, "in")],
            types: ["address"]);
        if (p != null) {
          setState(() {
            widget.textField.place = p.description;
          });
        }
        widget.onDelete;
      },
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      style: TextStyle(color: Colors.black, fontSize: 16.0),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        errorStyle: TextStyle(color: Colors.white),
        hintText: widget.textField.hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: Colors.amber,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }
}
