#
enable :sessions

get "/admin/registrations" do
  @registrations = UserRegistrations.all

  haml :"admin/registrations"
end
