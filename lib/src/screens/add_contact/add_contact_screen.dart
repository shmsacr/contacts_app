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
import '../../core/data/model/city.dart';
import '../../core/data/model/contacts.dart';

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
                        BlocBuilder<CityBloc, CityState>(
                          builder: (context, state) {
                            if (state is CityLoadingState) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is CityLoadedState) {
                              List<City> cityOptions = state.cities;
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                child: FormBuilderDropdown<City>(
                                  name: 'city',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
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
                                      fontSize: 25,
                                    ),
                                    suffix: IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        _formKey.currentState!.fields['city']
                                            ?.reset();
                                      },
                                    ),
                                    hintText: "Select city",
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
                                ),
                              );
                            } else {
                              return const Center(child: Text("Error"));
                            }
                          },
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
                                      'city_id': 12049,
                                      'town_id': 2175,
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
          height: 300,
          width: 400,
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
            fontSize: 25,
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
