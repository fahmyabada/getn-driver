import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:getn_driver/data/model/CurrentLocation.dart';
import 'package:getn_driver/data/model/predictionsPlaceSearch/Predictions.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/ui/trip/tripCreate/trip_create_cubit.dart';

class SearchMapScreen extends StatefulWidget {
  const SearchMapScreen({Key? key}) : super(key: key);

  @override
  State<SearchMapScreen> createState() => _SearchMapScreenState();
}

class _SearchMapScreenState extends State<SearchMapScreen> {
  final TextEditingController controller = TextEditingController();
  String? suggestionDescription;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripCreateCubit(),
      child: BlocConsumer<TripCreateCubit, TripCreateState>(
        listener: (context, state) {
          if (state is SearchLocationErrorState) {
            Navigator.pop(context);
            showToastt(
                text: state.message,
                state: ToastStates.error,
                context: context);
          } else if (state is SetPlaceDetailsSuccessState) {
            Navigator.of(context).pop(CurrentLocation(
                description: suggestionDescription,
                latitude: state.data?.lat!,
                longitude: state.data?.lng!,
            firstTime: true));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.r),
              width: 1.sw,
              alignment: Alignment.topCenter,
              child: TypeAheadField(
                hideOnLoading: true,
                textFieldConfiguration: TextFieldConfiguration(
                  controller: controller,
                  textInputAction: TextInputAction.search,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.streetAddress,
                  cursorColor: black,
                  style: const TextStyle(color: white),
                  decoration: InputDecoration(
                    hintText: 'search location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide:
                          const BorderSide(style: BorderStyle.none, width: 0),
                    ),
                    hintStyle: const TextStyle(color: white),
                    filled: true,
                    fillColor: grey2,
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  return pattern.isNotEmpty
                      ? await TripCreateCubit.get(context).searchLocation(pattern)
                      : [Predictions(placeId: "", description: "")];
                },
                itemBuilder: (context, Predictions suggestion) {
                  return suggestion.description!.isNotEmpty
                      ? Container(
                          width: 1.sw,
                          padding: EdgeInsets.all(10.r),
                          child: Row(children: [
                            Icon(
                              Icons.location_on,
                              size: 20.sp,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Expanded(
                              child: Text(suggestion.description!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.color,
                                        fontSize: 17.sp,
                                      )),
                            ),
                          ]),
                        )
                      : Container();
                },
                onSuggestionSelected: (Predictions suggestion) {
                  print("My location is " + suggestion.description!);
                  setState(() {
                    suggestionDescription = suggestion.description!;
                    TripCreateCubit.get(context)
                        .getPlaceDetails(suggestion.placeId!);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
