// import 'package:doi_rac_app/src/core/common/bloc/export_bloc_lib.dart';
// import 'package:doi_rac_app/src/core/common/db_keys_local.dart';
// import 'package:doi_rac_app/src/core/common/function/share_pref.dart';
// import 'package:doi_rac_app/src/core/common/widget/dropdown/custom_dropdown.dart';
// import 'package:doi_rac_app/src/core/ext/int_ext.dart';
// import 'package:doi_rac_app/src/feature/address/presentation/bloc/address_bloc.dart';
// import 'package:doi_rac_app/src/feature/address/presentation/bloc/local_bloc.dart';
// import 'package:doi_rac_app/src/feature/exchange_trash/data/models/local_model.dart';
// import 'package:flutter/material.dart';

// class SelectLocalWidget extends StatefulWidget {
//   const SelectLocalWidget({
//     super.key,
//     this.provinceId,
//     this.districtId,
//     this.wardId,
//     this.validate = false,
//     required this.localBloc,
//     this.focusProvince,
//     this.focusDistrict,
//     this.focusWard,  this.validateFocus,
//   });

//   final int? provinceId;
//   final int? districtId;
//   final int? wardId;
//   final FocusNode? focusProvince;
//   final FocusNode? focusDistrict;
//   final FocusNode? focusWard;
//   final bool validate;
//   final LocalBloc localBloc;
//   final void Function(int)? validateFocus;
//   @override
//   State<SelectLocalWidget> createState() => _SelectLocalWidgetState();
// }

// class _SelectLocalWidgetState extends State<SelectLocalWidget> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     init();
//   }

//   init() async {
//     await widget.localBloc.getProvince(true);
//     widget.localBloc.checkLocation(
//       provinceId: widget.provinceId.validator(),
//       districtId: widget.districtId.validator(),
//       wardId: widget.wardId.validator(),
//       isAddress: true,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     AddressBloc aBloc = context.read<AddressBloc>();
//     return BlocBuilder<LocalBloc, CubitState>(
//       bloc: widget.localBloc,
//       builder: (context, state) {
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomDropdown(
//               key: const Key('province'),
//               focusNode: widget.focusProvince,
//               value: widget.localBloc.province,
//               item: widget.localBloc.listProvince
//                   .map(
//                     (e) => ModelDropdown<LocalModel>(
//                       name: e.name,
//                       value: e,
//                     ),
//                   )
//                   .toList(),
//               hint: 'Tỉnh/thành phố',
//               onChanged: (value) {
//                 widget.localBloc
//                     .setProvince(value as LocalModel, isAddress: true);
//                 SharedPrefs.saveBool(DbKeysLocal.saveAddress, false);
//               },
//               validator: widget.validate
//                   ? (value) {
//                       if (value == null) {
//                         if(widget.validateFocus != null) {
//                           widget.validateFocus!(0);
//                         }
//                         return 'Vui lòng chọn tỉnh/thành phố';
//                       }
//                       return null;
//                     }
//                   : null,
//             ),
//             6.height,
//             CustomDropdown(
//               key: const Key('district'),
//               focusNode: widget.focusDistrict,
//               value: widget.localBloc.district,
//               item: widget.localBloc.listDistrict
//                   .map(
//                     (e) => ModelDropdown<LocalModel>(
//                       name: e.name,
//                       value: e,
//                     ),
//                   )
//                   .toList(),
//               hint: 'Quận/huyện',
//               onChanged: (value) {
//                 widget.localBloc.setDistrict(value as LocalModel);
//                 SharedPrefs.saveBool(DbKeysLocal.saveAddress, false);
//                 setState(() {});
//               },
//               validator: widget.validate
//                   ? (value) {
//                       if (value == null) {
//                         if(widget.validateFocus != null) {
//                           widget.validateFocus!(1);
//                         }
//                         return 'Vui lòng chọn quận/huyện';
//                       }
//                       return null;
//                     }
//                   : null,
//             ),
//             6.height,
//             CustomDropdown(
//               key: const Key('ward'),
//               value: widget.localBloc.ward,
//               focusNode: widget.focusWard,
//               item: widget.localBloc.listWard.isNotEmpty
//                   ? widget.localBloc.listWard
//                       .map(
//                         (e) => ModelDropdown<LocalModel>(
//                           name: e.name,
//                           value: e,
//                         ),
//                       )
//                       .toList()
//                   : [],
//               hint: 'Xã/phường',
//               onChanged: (value) {
//                 widget.localBloc.setWard(value as LocalModel);
//                 SharedPrefs.saveBool(DbKeysLocal.saveAddress, false);
//               },
//               validator: widget.validate
//                   ? (value) {
//                       if (value == null) {
//                         if(widget.validateFocus != null) {
//                           widget.validateFocus!(2);
//                         }
//                         return 'Vui lòng chọn xã/phường';
//                       }
//                       return null;
//                     }
//                   : null,
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
