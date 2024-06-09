import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldPassword extends StatefulWidget {
  final double? radius;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final Color? iconColor;
  final String? hintText;
  final TextEditingController controller;

  const TextFormFieldPassword({
    super.key,
    this.radius = 10,
    this.borderColor = Colors.black,
    this.prefixIcon,
    this.suffixIcon = Icons.visibility_sharp,
    this.focusedBorderColor = Colors.black,
    this.iconColor,
    this.validator,
    this.onChanged,
    required this.controller,
    this.hintText,
  });

  @override
  State<TextFormFieldPassword> createState() => _TextFormFieldPasswordState();
}

class _TextFormFieldPasswordState extends State<TextFormFieldPassword> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: widget.focusedBorderColor,
      controller: widget.controller,
      decoration: InputDecoration(
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Colors.black26),
        hintText: widget.hintText ?? ("Password"),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius!),
            borderSide: BorderSide(color: widget.borderColor!)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius!),
          borderSide: BorderSide(color: widget.focusedBorderColor!),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius!),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius!),
          borderSide: const BorderSide(color: Colors.red),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: widget.iconColor,
            size: 18,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      validator: widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required.';
            } else {
              return null;
            }
          },
      obscureText: _obscureText,
      onChanged: widget.onChanged,
    );
  }
}

class TextFormFieldEmail extends StatelessWidget {
  final double? radius;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final TextEditingController controller;
  const TextFormFieldEmail({
    super.key,
    this.radius = 10,
    this.borderColor = Colors.grey,
    this.prefixIcon,
    this.focusedBorderColor = Colors.grey,
    this.validator,
    this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: focusedBorderColor,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Colors.black26),
        hintText: "Email",
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius!),
            borderSide: BorderSide(color: borderColor!, width: 1.0)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide: BorderSide(color: focusedBorderColor!, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Email is required.';
            } else {
              return null;
            }
          },
      onChanged: onChanged,
    );
  }
}

class TextFormFieldCustom extends StatelessWidget {
  final double? radius;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final String? validatorMessage;

  const TextFormFieldCustom({
    super.key,
    this.radius = 10,
    this.borderColor = Colors.grey,
    this.prefixIcon,
    this.focusedBorderColor = Colors.grey,
    this.validator,
    this.onChanged,
    required this.controller,
    required this.hintText,
    this.validatorMessage,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: focusedBorderColor,
      controller: controller,
      keyboardType: TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Colors.black26),
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius!),
            borderSide: BorderSide(color: borderColor!, width: 1.0)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide: BorderSide(color: focusedBorderColor!, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return validatorMessage;
            } else {
              return null;
            }
          },
      onChanged: onChanged,
    );
  }
}

class TextFormFieldPhone extends StatelessWidget {
  final double? radius;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final TextEditingController controller;

  const TextFormFieldPhone({
    super.key,
    this.radius = 10,
    this.borderColor = Colors.black,
    this.prefixIcon,
    this.focusedBorderColor = Colors.black,
    this.validator,
    this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ],
      controller: controller,
      cursorColor: focusedBorderColor,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Colors.black26),
        hintText: "Phone Number",
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius!),
            borderSide: BorderSide(color: focusedBorderColor!)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide: BorderSide(color: focusedBorderColor!),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius!),
            borderSide: BorderSide(color: focusedBorderColor!)),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Phone number is required.';
            } else {
              return null;
            }
          },
      onChanged: onChanged,
    );
  }
}

class TextFormFieldFullName extends StatelessWidget {
  final double? radius;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final TextEditingController controller;

  final String hintText;

  const TextFormFieldFullName({
    super.key,
    this.radius = 10,
    this.borderColor = Colors.black,
    this.suffixIcon,
    this.focusedBorderColor = Colors.black,
    this.validator,
    this.onChanged,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      cursorColor: focusedBorderColor,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Colors.black26),
        hintText: hintText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius!),
            borderSide: BorderSide(color: borderColor!)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius!),
            borderSide: BorderSide(color: borderColor!)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide: BorderSide(color: focusedBorderColor!),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Full name is required.';
            } else {
              return null;
            }
          },
      onChanged: onChanged,
    );
  }
}

class TextFormFieldSearch extends StatelessWidget {
  const TextFormFieldSearch({
    super.key,
    this.radius = 10,
    this.borderColor = Colors.grey,
    this.suffixIcon,
    this.focusedBorderColor = Colors.black,
    this.validator,
    this.onChanged,
    required this.controller,
    this.icon,
    this.isPrefix = false,
  });
  final Widget? icon;
  final double? radius;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final TextEditingController controller;
  final bool isPrefix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.disabled,
      controller: controller,
      cursorColor: focusedBorderColor,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: isPrefix ? icon ?? const Icon(Icons.search) : null,
        suffixIcon: isPrefix ? null : icon ?? const Icon(Icons.search),
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Colors.black87),
        hintText: "Search",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius!),
            borderSide: BorderSide(color: borderColor!)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide: BorderSide(color: focusedBorderColor!),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
