enum Status { loading, success, error }

//This class will manage the status of the UI based on the current status of the reponse of the API call
class ApiResponse {
  final Status status;
  final Exception? error;

  ApiResponse.loading(this.error) : status = Status.loading;
  ApiResponse.success(this.error) : status = Status.success;
  ApiResponse.error(this.error) : status = Status.error; 
}