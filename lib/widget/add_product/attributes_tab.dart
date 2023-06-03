import 'package:flutter/material.dart';
import 'package:marketdo_app_vendor/provider/product_provider.dart';
import 'package:provider/provider.dart';

class AttributeTab extends StatefulWidget {
  const AttributeTab({super.key});

  @override
  State<AttributeTab> createState() => _AttributeTabState();
}

class _AttributeTabState extends State<AttributeTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<String> _sizeList = [];
  final _sizeText = TextEditingController();
  bool? _saved = false;
  bool _entered = false;
  String? selectedUnit;
  final List<String> _length = [
    'Inch (in)',
    'Feet (ft)',
    'Yard (yd)',
    'Mile (mi)',
    'Meter (m)',
    'Kilometer (km)'
  ];
  final List<String> _weight = [
    'Ounce (oz)',
    'Pound (lb)',
    'Gram (g)',
    'Kilogram (kg)',
    'Metric Ton (MT)',
    'Carat (ct)'
  ];
  final List<String> _volume = [
    'Fluid Ounce(fl oz)',
    'Cup (c)' 'Pint (pt)',
    'Quart (qt)',
    'Gallon (gal)',
    'Milliliter (ml)',
    'Liter (L)'
  ];
  final List<String> _box = [
    'Unit (u)',
    'Piece (pc)',
    'Box (box)',
    'Carton (ctn)'
  ];
  final List<String> _bundles = ['Bundle (bdl)', 'Pack (pk)', 'Batch (bch)'];
  final List<String> _container = [
    'Can (can)',
    'Bottle (btl)',
    'Case (case)',
    'Crate (crate)',
    'Bag (bag)',
    'Sack (sack)'
  ];
  final List<String> _units = [];

  @override
  void initState() {
    _units.addAll(_length);
    _units.addAll(_weight);
    _units.addAll(_volume);
    _units.addAll(_box);
    _units.addAll(_bundles);
    _units.addAll(_container);
    _units.sort();
    super.initState();
  }

  Widget _formField(
      {String? label,
      TextInputType? inputType,
      void Function(String)? onChanged,
      int? minLine,
      int? maxLine}) {
    return TextFormField(
        keyboardType: inputType,
        decoration: InputDecoration(label: Text(label!)),
        onChanged: onChanged,
        minLines: minLine,
        maxLines: maxLine);
  }

  Widget _unitDropDown(ProductProvider provider) => DropdownButtonFormField(
      dropdownColor: Colors.yellow,
      menuMaxHeight: 300,
      value: selectedUnit,
      hint: const Text('Select Unit', style: TextStyle(fontSize: 16)),
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      onChanged: (String? newValue) {
        setState(() {
          selectedUnit = newValue!;
          provider.getFormData(unit: newValue);
        });
      },
      items: _units
          .map<DropdownMenuItem<String>>((String value) =>
              DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                      style:
                          const TextStyle(fontFamily: 'Lato', fontSize: 12))))
          .toList(),
      validator: (value) => value!.isEmpty ? 'Select unit' : null);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(
        builder: (context, provider, _) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(children: [
              _formField(
                  label: 'Brand',
                  inputType: TextInputType.text,
                  onChanged: (value) => provider.getFormData(brand: value)),
              _unitDropDown(provider),
              Row(children: [
                Expanded(
                    child: TextFormField(
                        controller: _sizeText,
                        decoration: const InputDecoration(label: Text('Size')),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() => _entered = true);
                          }
                        })),
                if (_entered)
                  ElevatedButton(
                      onPressed: () => setState(() {
                            _sizeList.add(_sizeText.text);
                            _sizeText.clear();
                            _entered = false;
                            _saved = false;
                          }),
                      child: const Text('Add'))
              ]),
              const SizedBox(height: 10),
              if (_sizeList.isNotEmpty)
                SizedBox(
                    height: 50,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _sizeList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                  onLongPress: () => setState(() {
                                        _sizeList.removeAt(index);
                                        provider.getFormData(
                                            sizeList: _sizeList);
                                      }),
                                  child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Colors.purpleAccent),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text(_sizeList[index],
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold)))))));
                        })),
              if (_sizeList.isNotEmpty)
                Column(children: [
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('* long press to delete',
                          style: TextStyle(color: Colors.grey, fontSize: 12))),
                  Row(children: [
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () => setState(() {
                                  provider.getFormData(sizeList: _sizeList);
                                  _saved = true;
                                }),
                            child: Text(
                                _saved == true ? 'Saved' : 'Press to Save')))
                  ])
                ]),
              _formField(
                  label: 'Add other details',
                  maxLine: 2,
                  onChanged: (value) =>
                      provider.getFormData(otherDetails: value))
            ])));
  }
}
