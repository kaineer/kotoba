#
#
#

get "/bookmark/:id/set" do
  @user = User.current
  @tango = Tango[ params[ :id ].to_i ]

  @user.mark( @tango.index )

  redirect Url.user
end

get "/bookmark/:id/unset" do
  @user = User.current
  @tango = Tango[ params[ :id ].to_i ]
  
  @user.unmark( @tango.index )
  
  redirect Url.user
end
