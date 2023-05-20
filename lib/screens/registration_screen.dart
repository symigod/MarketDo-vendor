import 'dart:io';
import 'package:csc_picker/csc_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketdo_app_vendor/firebase_services.dart';
import 'package:marketdo_app_vendor/screens/landing_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

const List<String> list = <String>['Yes', 'No'];

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();
  final _businessName = TextEditingController();
  final _contactNumber = TextEditingController();
  final _email = TextEditingController();
  final _gstNumber = TextEditingController();
  final _pinCode = TextEditingController();
  final _landMark = TextEditingController();
  String? _bName;
  String? _taxStatus;
  XFile? _shopImage;
  String? _shopImageUrl;
  XFile? _logo;
  String? countryValue;
  String? stateValue;
  String? cityValue;
  String? _logoUrl;

  final ImagePicker _picker = ImagePicker();

  Widget _formField({TextEditingController? controller, String? label, TextInputType? type, String? Function(String?)? validator}){
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixText: controller == _contactNumber ? '+63' : null,

      ),
      validator:validator,

      onChanged: (value){
        if(controller == _businessName){
          setState(() {
            _bName = value;
          });
        }
      },
    );
  }


  Future<XFile?>_pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  _scaffold(message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message,
    ), action: SnackBarAction(
      label: 'OK',
      onPressed: (){
        ScaffoldMessenger.of(context).clearSnackBars();
      },
    ),));
  }

  _saveToDB() {
    if (_shopImage == null) {
      _scaffold('Shop Image not selected');
      return;
    }
    if (_logo == null) {
      _scaffold('Logo not selected');
      return;
    }

    if (_formKey.currentState!.validate()) {
      {
        if (countryValue == null || stateValue == null || cityValue == null) {
          _scaffold('Select address field completely');
          return;
        }
        EasyLoading.show(status: 'Please wait...');
        _services.uploadImage(
            _shopImage, 'vendors/${_services.user!.uid}/shopImage.jpg').then((
            String? url) {
          if (url != null) {
            setState(() {
              _shopImageUrl = url;
            });
          }
        }).then((value) {
          _services.uploadImage(
              _logo, 'vendors/${_services.user!.uid}/logo.jpg').then((url) {
            setState(() {
              _logoUrl = url;
            });
          }).then((value) {
            _services.addVendor(
                data: {
                  'shopImage': _shopImageUrl,
                  'logo': _logoUrl,
                  'businessName': _businessName.text,
                  'mobile': '+63${_contactNumber.text}',
                  'email': _email.text,
                  'taxRegistered': _taxStatus,
                  'tinNumber': _gstNumber.text.isEmpty ? null : _gstNumber.text,
                  'pinCode': _pinCode.text,
                  'landMark': _landMark.text,
                  'country': countryValue,
                  'state': stateValue,
                  'city': cityValue,
                  'approved': false,
                  'uid': _services.user!.uid,
                  'time': DateTime.now(),
                }
            ).then((value) {
              EasyLoading.dismiss();
              return Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const LandingScreen(),
              ),);
            });
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 240,
                child: Stack(
                  children: [
                    _shopImage == null ?
                    Container(
                        color: Colors.greenAccent,
                        height: 240,
                        child: TextButton(
                          child: Center(
                            child: Text(
                              'Tap to add shop image',
                              style: TextStyle(color: Colors.grey.shade800),
                            ),
                          ),
                          onPressed: () {
                            _pickImage().then((value) {
                              setState(() {
                                _shopImage = value;
                              });
                            });
                          },
                        )
                    ) : InkWell(
                      onTap: () {
                        _pickImage().then((value) {
                          setState(() {
                            _shopImage = value;
                          });
                        });
                      },
                      child: Container(
                        height: 240,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          image: DecorationImage(
                            opacity: 100,
                            image: FileImage(File(_shopImage!.path),),
                            fit: BoxFit.cover,

                          ),

                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        actions: [
                          IconButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                            },
                            icon: const Icon(Icons.exit_to_app),
                          ),
                        ],
                      ),),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                _pickImage().then((value) {
                                  setState(() {
                                    _logo = value;
                                  });
                                });
                              },
                              child: Card(
                                elevation: 4,
                                child: _logo == null ? const SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Center(child: Text('+'),),

                                ) : ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Image.file(File(_logo!.path),),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Text(
                              _bName == null ? '' : _bName!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
                child: Column(
                  children: [
                    _formField(
                        controller: _businessName,
                        label: 'Business Name',
                        type: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Business name';
                          }
                        }
                    ),
                    _formField(
                        controller: _contactNumber,
                        label: 'Contact Number',
                        type: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter contact number';
                          }
                        }
                    ),
                    _formField(
                        controller: _email,
                        label: 'Email Address',
                        type: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter email';
                          }
                          bool _isValid = (EmailValidator.validate(value));
                          if (_isValid == false) {
                            return 'Invalid Email';
                          }
                        }
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        const Text('Tax Registered: '),
                        Expanded(
                          child: DropdownButtonFormField(
                              value: _taxStatus,
                              validator: (value) {
                                if (value == null) {
                                  return 'Select Tax status';
                                }
                              },
                              hint: const Text('Select'),
                              items: list.map<DropdownMenuItem<String>>((
                                  String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _taxStatus = value;
                                });
                              }),
                        )
                      ],
                    ),
                    if(_taxStatus == 'Yes')
                      _formField(
                          controller: _gstNumber,
                          label: 'GST Number',
                          type: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter GST Number';
                            }
                          }
                      ),
                    _formField(
                        controller: _pinCode,
                        label: 'PIN Code',
                        type: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Pin code';
                          }
                        }
                    ),
                    _formField(
                        controller: _landMark,
                        label: 'Landmark',
                        type: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter a Landmark';
                          }
                        }
                    ),
                    const SizedBox(height: 10,),

                    CSCPicker(

                      ///Enable disable state dropdown [OPTIONAL PARAMETER]
                      showStates: true,

                      /// Enable disable city drop down [OPTIONAL PARAMETER]
                      showCities: true,

                      ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                      flagState: CountryFlag.DISABLE,

                      ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                      dropdownDecoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius
                              .circular(
                              10)),
                          color: Colors.white,
                          border:
                          Border.all(color: Colors.grey.shade300, width: 1)),

                      ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                      disabledDropdownDecoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius
                              .circular(
                              10)),
                          //color: Colors.grey.shade300,
                          border:
                          Border.all(color: Colors.grey.shade300, width: 1)),

                      ///placeholders for dropdown search field
                      countrySearchPlaceholder: "Country",
                      stateSearchPlaceholder: "State",
                      citySearchPlaceholder: "City",

                      ///labels for dropdown
                      countryDropdownLabel: "*Country",
                      stateDropdownLabel: "*State",
                      cityDropdownLabel: "*City",

                      ///Default Country
                      defaultCountry: CscCountry.Philippines,

                      ///Disable country dropdown (Note: use it with default country)
                      //disableCountry: true,

                      ///Country Filter [OPTIONAL PARAMETER]
                      countryFilter: const [
                        CscCountry.Philippines,
                        CscCountry.United_States,
                        CscCountry.Canada
                      ],

                      ///selected item style [OPTIONAL PARAMETER]
                      selectedItemStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),

                      ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                      dropdownHeadingStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),

                      ///DropdownDialog Item style [OPTIONAL PARAMETER]
                      dropdownItemStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),

                      ///Dialog box radius [OPTIONAL PARAMETER]
                      dropdownDialogRadius: 10.0,

                      ///Search bar radius [OPTIONAL PARAMETER]
                      searchBarRadius: 10.0,

                      ///triggers once country selected in dropdown
                      onCountryChanged: (value) {
                        setState(() {
                          ///store value in country variable
                          countryValue = value;
                        });
                      },

                      ///triggers once state selected in dropdown
                      onStateChanged: (value) {
                        setState(() {
                          ///store value in state variable
                          stateValue = value;
                        });
                      },

                      ///triggers once city selected in dropdown
                      onCityChanged: (value) {
                        setState(() {
                          ///store value in city variable
                          cityValue = value;
                        });
                      },
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
        persistentFooterButtons: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _saveToDB,
                    child: const Text('Register'),

                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

