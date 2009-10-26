#
#
#

get "/bookmark/:id/set" do
  User.current.mark( params[ :id ].to_i )
  redirect Url.user
end

get "/bookmark/:id/unset" do
  User.current.unmark( params[ :id ].to_i )
  redirect Url.user
end

get "/bookmark/:id/toggle" do
  code = User.current.toggle_mark( params[ :id ].to_i )

  (code == :created ? "Created" : "Destroyed").inspect
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
