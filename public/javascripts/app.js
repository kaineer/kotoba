//
//
//
$( document ).ready( function() {
  var div = $("#login");

  if( div.attr( "name" ) ) {
    div.tag( "div", function( sd ) {
      sd.tag( "span", "Hello, " + div.attr( "name" ) + ".&nbsp;" );
      sd.tag( "a", { href: "/logout" }, "logout" );
    } );
  } else {
    div.tag( "div", function( div ) {
      div.tag( "span", "Hello, guest!&nbsp;" );
      div.tag( "a", { href: "#", "class": "login" }, "login" );
      div.tag( "span", "&nbsp;or&nbsp;" );
      div.tag( "a", { href: "/register" }, "register" );
    } );
  }

  $( "a.login" ).live( "click", function() {
    $( "#login" ).html( "<div>" );
    var form = $( "#login div" ).tag( "form", {action: "/login", method: "post"} );

    form.tag( "span", "Login:&nbsp;" );
    var login = form.tag( "input", {type: "text", size: 10, name: "login", value: ""} );
    form.tag( "span", "&nbsp;&nbsp;password:&nbsp;" );
    form.tag( "input", {type: "password", size: 10, name: "password", value: ""} );

    $( "#login div input:text" ).focus();

    return false;
  } );

  $( "#login input, #title input" ).live( "keypress", function( e ) {
    if( e.which == 13 ) { $( "#login form" ).submit(); }
    return true;
  } );

  $( ".bookmark" ).live( "click", function() {
    /// TODO
  } );

  $( "#bookmarks table tr:odd" ).addClass( "odd" );
} );
