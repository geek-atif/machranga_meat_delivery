class ApiResponse<T> {
  Status status;

  T data;

  String message;

  ApiResponse.loading(this.message) : status = Status.LOADING;

  ApiResponse.completed(this.data) : status = Status.COMPLETED;

  ApiResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "StatusM : $status \n MessageM : $message \n DataM : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR }
