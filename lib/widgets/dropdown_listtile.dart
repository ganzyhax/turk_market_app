import 'package:flutter/material.dart';
import 'package:turkmarket_app/constants.dart';

class DropdownListtile extends StatefulWidget {
  final bool isSelected;
  final String title;
  final List colors;
  final List selectedValues;
  final bool withImage;
  final Function(List)? updateMessageCallback;

  final Function() function;
  const DropdownListtile(
      {super.key,
      required this.updateMessageCallback,
      required this.isSelected,
      required this.title,
      required this.withImage,
      required this.selectedValues,
      required this.function,
      required this.colors});

  @override
  State<DropdownListtile> createState() => _DropdownListtileState();
}

class _DropdownListtileState extends State<DropdownListtile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.function,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[50], borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                  leading: Text(
                    widget.title,
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: (widget.isSelected == true)
                      ? Icon(Icons.arrow_drop_up)
                      : Icon(Icons.arrow_drop_down)),
              Visibility(
                visible: widget.isSelected,
                child: Wrap(
                    runSpacing: 20,
                    spacing: 20,
                    children: widget.colors
                        .map<Widget>((e) => (widget.withImage == false)
                            ? InkWell(
                                onTap: () {
                                  if (widget.selectedValues.contains(e)) {
                                    widget.selectedValues.remove(e);
                                  } else {
                                    widget.selectedValues.add(e);
                                  }
                                  setState(() {});
                                  widget.updateMessageCallback
                                      ?.call(widget.selectedValues);
                                },
                                child: Container(
                                  width: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(e.toString()),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            (widget.selectedValues.contains(e))
                                                ? kprimaryColor
                                                : Colors.black),
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  if (widget.selectedValues
                                      .contains(e['brandName'])) {
                                    widget.selectedValues
                                        .remove(e['brandName']);
                                  } else {
                                    widget.selectedValues.add(e['brandName']);
                                  }
                                  setState(() {});
                                },
                                child: Container(
                                  width: 80,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(e['brandImage']),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: (widget.selectedValues
                                                .contains(e['brandName']))
                                            ? kprimaryColor
                                            : Colors.black,
                                        width: 2),
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ))
                        .toList()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
