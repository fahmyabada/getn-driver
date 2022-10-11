import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:getn_driver/data/model/predictionsPlaceSearch/Predictions.dart';
import 'package:getn_driver/presentation/tripDetails/trip_details_cubit.dart';

class LocationSearchDialog extends StatelessWidget {
  const LocationSearchDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Container(
      margin: EdgeInsets.only(top: 50.h, left: 10.r, right: 10.r),
      padding: EdgeInsets.all(5.r),
      width: 1.sw,
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: TypeAheadField(
          hideOnLoading: true,
          textFieldConfiguration: TextFieldConfiguration(
            controller: controller,
            textInputAction: TextInputAction.search,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.streetAddress,
            decoration: InputDecoration(
              hintText: 'search location',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(style: BorderStyle.none, width: 0),
              ),
              hintStyle: Theme.of(context).textTheme.headline2?.copyWith(
                    fontSize: 16.sp,
                    color: Theme.of(context).disabledColor,
                  ),
              filled: true,
              fillColor: Theme.of(context).cardColor,
            ),
          ),
          suggestionsCallback: (pattern) async {
            return pattern.isNotEmpty
                ? await TripDetailsCubit.get(context).searchLocation(pattern)
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
                      Expanded(
                        child: Text(suggestion.description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.headline2?.copyWith(
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
            TripDetailsCubit.get(context).setSuggestionSelected(suggestion);
            TripDetailsCubit.get(context).getPlaceDetails(suggestion.placeId!);
            //Get.find<LocationController>().setLocation(suggestion.placeId!, suggestion.description!, mapController);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
