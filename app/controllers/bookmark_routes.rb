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


get "/bookmarks/print" do
  @user = User.current
  @bookmarks = @user.user_bookmarks.sort_by{|b|b.tango_id}

  haml :print
end

get "/bookmarks/clear" do
  User.current.clear_bookmarks rescue nil
  redirect Url.user
end
