class AdminController < ActionController::Base
  http_basic_authenticate_with name: ENV["http_basic_authenticate_with_name"], password: ENV["http_basic_authenticate_with_password"]
end
