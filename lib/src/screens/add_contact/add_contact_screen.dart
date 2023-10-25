import 'dart:io';

import 'package:contacts_app/src/core/bloc/city_bloc/city_bloc.dart';
import 'package:contacts_app/src/core/bloc/contacts_bloc/contacts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/bloc/city_bloc/city_state.dart';
import '../../core/bloc/contacts_bloc/contacts_event.dart';
import '../../core/bloc/contacts_bloc/contacts_state.dart';
import '../../core/bloc/town/town_bloc.dart';
import '../../core/data/model/city.dart';
import '../../core/data/model/contacts.dart';
import '../../core/data/model/town.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({Key? key}) : super(key: key);

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  var _phoneNumberController = TextEditingController();
  late TextEditingController _controller;
  List<String> genderOptions = ['Male', 'Female', 'Other'];
  File? _uploadFile;
  late int selectedCity;
  late int selectedTown;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _formKey.currentState?.reset();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> upLoadCamere() async {
    XFile? getFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 1);
    setState(() {
      _uploadFile = File(getFile!.path);
    });
  }

  Future<void> upLoadGallery() async {
    XFile? getFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _uploadFile = File(getFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff003344),
          title: Text("Add Contact"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        child: _uploadFile != null
                            ? ClipOval(
                                child: Image.file(
                                  _uploadFile!,
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(Icons.person, size: 50),
                      ),
                      Positioned(
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: IconButton(
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      alertDialog()),
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                              )),
                        ),
                      )
                    ],
                  ),
                  FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        _NameFormBuilder(),
                        const SizedBox(height: 16.0),
                        _PhoneFormBuilder(
                            phoneNumberController: _phoneNumberController),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.065,
                              width: MediaQuery.of(context).size.width / 2.3,
                              child: BlocBuilder<CityBloc, CityState>(
                                builder: (context, state) {
                                  if (state is CityLoadedState) {
                                    List<City> cityOptions = state.cities;
                                    return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      child: FormBuilderDropdown<City>(
                                        name: 'city',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.blueAccent,
                                              width: 3,
                                            ),
                                          ),
                                          filled: true,
                                          labelText: 'City',
                                          labelStyle: const TextStyle(
                                            color: Color(0xff072027),
                                            fontSize: 18,
                                          ),
                                          suffix: IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              _formKey
                                                  .currentState!.fields['city']
                                                  ?.reset();
                                            },
                                          ),
                                          hintText: "Select city",
                                        ),
                                        isExpanded: true,
                                        items: cityOptions
                                            .map((city) =>
                                                DropdownMenuItem<City>(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  value: city,
                                                  child: Text(city.city_name),
                                                  onTap: () {
                                                    setState(() {
                                                      selectedCity =
                                                          city.city_id;
                                                      BlocProvider.of<TownBloc>(
                                                              context)
                                                          .add(LoadTownEvent(
                                                              city_id:
                                                                  selectedCity));
                                                    });
                                                  },
                                                ))
                                            .toList(),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.065,
                                      width: MediaQuery.of(context).size.width /
                                          2.2,
                                      child: const TextField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.blueAccent,
                                              width: 3,
                                            ),
                                          ),
                                          filled: true,
                                          labelText: 'City',
                                          labelStyle: TextStyle(
                                            color: Color(0xff072027),
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.065,
                              width: MediaQuery.of(context).size.width / 2.3,
                              child: BlocBuilder<TownBloc, TownState>(
                                builder: (context, state) {
                                  if (state is TownLoadedState) {
                                    List<Town> townOptions = state.towns;
                                    return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      child: FormBuilderDropdown<Town>(
                                        name: 'town',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.blueAccent,
                                              width: 3,
                                            ),
                                          ),
                                          filled: true,
                                          labelText: 'Town',
                                          labelStyle: const TextStyle(
                                            color: Color(0xff072027),
                                            fontSize: 18,
                                          ),
                                          suffix: IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              _formKey
                                                  .currentState!.fields['town']
                                                  ?.reset();
                                            },
                                          ),
                                          hintText: "Select city",
                                        ),
                                        isExpanded: true,
                                        items: townOptions
                                            .map((town) =>
                                                DropdownMenuItem<Town>(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  value: town,
                                                  child: Text(town.townName),
                                                  onTap: () {
                                                    setState(() {
                                                      selectedTown =
                                                          town.townId;
                                                    });
                                                  },
                                                ))
                                            .toList(),
                                      ),
                                    );
                                  }
                                  if (state is TownErrorState) {
                                    return const Center(child: Text("Error"));
                                  } else {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.065,
                                      width: MediaQuery.of(context).size.width /
                                          2.2,
                                      child: const TextField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.blueAccent,
                                              width: 3,
                                            ),
                                          ),
                                          filled: true,
                                          labelText: 'Town',
                                          labelStyle: TextStyle(
                                            color: Color(0xff072027),
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        BlocBuilder<ContactsBloc, ContactsState>(
                          builder: (context, state) {
                            return ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState
                                          ?.saveAndValidate() ??
                                      false) {
                                    final Contacts user = Contacts.fromJson({
                                      'kisi_ad':
                                          _formKey.currentState!.value["name"],
                                      'kisi_id': 0,
                                      'city_id': selectedCity,
                                      'town_id': selectedTown,
                                      'kisi_tel': _phoneNumberController.text,
                                    });
                                    context.read<ContactsBloc>().add(
                                        PostUserEvent(
                                            data: user, file: _uploadFile));
                                    final state = await context
                                        .read<ContactsBloc>()
                                        .stream
                                        .firstWhere((state) =>
                                            state is ContactsSuccessState ||
                                            state is ContactsErrorState);
                                    if (state is ContactsSuccessState) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                          "User created: ${user.kisi_ad}",
                                        )),
                                      );
                                    } else if (state is ContactsErrorState) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                          state.toString(),
                                        )),
                                      );
                                    }
                                    context
                                        .read<ContactsBloc>()
                                        .add(LoadUserEvent());
                                  } else {
                                    debugPrint('Invalid');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: Text(
                                  'Create',
                                  style: TextStyle(color: Colors.white),
                                ));
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget alertDialog() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.5,
          child: AlertDialog(
            title: const Text('Lütfen yükleme tipini seçiniz'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    upLoadCamere();
                  },
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Kamera',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    upLoadGallery();
                  },
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Galeri',
                        style: TextStyle(color: Colors.purple),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PhoneFormBuilder extends StatelessWidget {
  const _PhoneFormBuilder({
    super.key,
    required TextEditingController phoneNumberController,
  }) : _phoneNumberController = phoneNumberController;

  final TextEditingController _phoneNumberController;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      controller: _phoneNumberController,
      name: 'phoneNumber',
      decoration: const InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 3,
          ),
        ),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(),
        labelText: 'Telefon Numarası',
        labelStyle: TextStyle(
            color: Color(0xff072027),
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "Bu alan boş bırakılamaz."),
        FormBuilderValidators.equalLength(
          10,
          errorText: "10 Haneli telefon numarası giriniz.",
        ),
      ]),
    );
  }
}

class _NameFormBuilder extends StatelessWidget {
  const _NameFormBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: "name",
      decoration: const InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 3,
          ),
        ),
        border: OutlineInputBorder(),
        fillColor: Colors.white,
        filled: true,
        labelText: 'Kisi Adı',
        labelStyle: TextStyle(
          color: Color(0xff072027),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      validator: FormBuilderValidators.compose(
        [
          FormBuilderValidators.required(errorText: "Bu alan boş bırakılamaz."),
        ],
      ),
      onEditingComplete: () {
        FocusScope.of(context).nextFocus();
      },
    );
  }
}
