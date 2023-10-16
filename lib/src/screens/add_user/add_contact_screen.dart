import 'package:contacts_app/src/core/bloc/city_bloc/city_bloc.dart';
import 'package:contacts_app/src/core/model/contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../core/bloc/city_bloc/city_state.dart';
import '../../core/model/city.dart';

class AddUserScreen extends StatefulWidget {
  final Contacts? contacts;
  const AddUserScreen({this.contacts, Key? key}) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _phoneNumberController = TextEditingController();
  late TextEditingController _controller;
  List<String> genderOptions = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    PhoneInputFormatter.replacePhoneMask(
      countryCode: 'TR',
      newMask: '+00 (000) 000 00 00',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _formKey.currentState?.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late int selectedCity;
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Contact"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    FormBuilderTextField(
                      name: "name",
                      initialValue: widget.contacts?.kisi_ad,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Kisi Ad',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(
                              errorText: "Bu alan boş bırakılamaz."),
                        ],
                      ),
                      onEditingComplete: () {
                        FocusScope.of(context).nextFocus();
                      },
                    ),
                    const SizedBox(height: 16.0),
                    FormBuilderTextField(
                      controller: _phoneNumberController,
                      name: 'phoneNumber',
                      inputFormatters: [PhoneInputFormatter()],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Telefon Numarası'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Bu alan boş bırakılamaz."),
                        FormBuilderValidators.equalLength(
                          19,
                          errorText:
                              "Doğru formatta bir telefon numarası giriniz.",
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 65.0,
                          width: 150.0,
                          child: BlocBuilder<CityBloc, CityState>(
                            builder: (context, state) {
                              if (state is CityLoadingState) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (state is CityLoadedState) {
                                List<City> cityOptions = state.cities;
                                return FormBuilderDropdown<City>(
                                  name: 'city',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'City',
                                    suffix: IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        _formKey.currentState!.fields['city']
                                            ?.reset();
                                      },
                                    ),
                                    hintText: 'Select City',
                                  ),
                                  isExpanded: true,
                                  items: cityOptions
                                      .map((city) => DropdownMenuItem<City>(
                                            alignment:
                                                AlignmentDirectional.center,
                                            value: city,
                                            child: Text(city.city_name),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCity = value!.city_id;
                                    });
                                    print(selectedCity.toString());
                                  },
                                );
                              } else {
                                return const Center(child: Text("Error"));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
