abstract class FormSubmitStatus {
  const FormSubmitStatus();
}

class FormSubmitInitial extends FormSubmitStatus {
  const FormSubmitInitial();
}

class FormSubmitLoading extends FormSubmitStatus {
  const FormSubmitLoading();
}

class FormSubmitSuccess<T> extends FormSubmitStatus {
  const FormSubmitSuccess([this.data]);
  final T? data;
}

class FormSubmitError extends FormSubmitStatus {
  const FormSubmitError(this.message);
  final String message;
}
