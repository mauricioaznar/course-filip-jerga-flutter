import 'package:flutter/material.dart';

class SelectInput<T> extends StatefulWidget {
  final T? value;
  final Function(T) onChange;
  final String label;
  final List<T> items;

  SelectInput(
      {required Function(T) onChange,
      required List<T> items,
      required T? value,
      String? label})
      : onChange = onChange,
        items = items,
        value = value,
        label = label ?? 'Select input';

  @override
  State<StatefulWidget> createState() {
    return _SelectInputState<T>();
  }
}

class _SelectInputState<T> extends State<SelectInput<T>> {
  T? value = null;

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      builder: (FormFieldState<T> state) {
        return InputDecorator(
          decoration: InputDecoration(
            icon: const Icon(Icons.timer),
            labelText: widget.label,
          ),
          isEmpty: value == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isDense: true,
              onChanged: (T? newValue) {
                // setState(() {
                if (newValue != null) {
                  widget.onChange(newValue);
                  setState(() {
                    value = newValue;
                  });
                }
                // });
              },
              items: widget.items.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(item.toString()),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
