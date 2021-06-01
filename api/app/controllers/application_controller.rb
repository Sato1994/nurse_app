class ApplicationController < ActionController::API

include DeviseTokenAuth::Concerns::SetUserByToken

###### 適当なレスポンスを返すメソッド ######
  # def response_success(class_name, action_name)
  #   render status: 200, json: { status: 200, message: "Success #{class_name.capitalize} #{action_name.capitalize}" }
  # end

  # def response_bad_request
  #   render status: 400, json: { status: 200, message: "Bad Request" }
  # end

  # def response_conflict(class_name)
  #   render status: 409, json: { status: 409, message: "Conflict #{class_name}" }
  # end

  # def response_internal_server_error
  #   render status: 500, json: { status: 500, message: "Internal Server Error" }
  # end

  # def response_not_found(class_name, action_name)
  #   render status: 404, json: { status: 404, message: "Not Found #{}" }
  # end
end
