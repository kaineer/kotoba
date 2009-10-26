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

  $( ".notice, .error, .success" ).click( function() {
    $( this ).remove();
    return false;
  } );

  $( "a.login" ).live( "click", function() {
    $( "#login" ).html( "<div>" );
    var form = $( "#login div" ).tag( "form", {action: "/login", method: "post", "class": "instant"} );

    form.tag( "span", "Login:&nbsp;" );
    var login = form.tag( "input", {type: "text", size: 10, name: "login", value: ""} );
    form.tag( "span", "&nbsp;&nbsp;password:&nbsp;" );
    form.tag( "input", {type: "password", size: 10, name: "password", value: ""} );

    $( "#login div input:text" ).focus();

    return false;
  } );

  $( "form.instant input" ).live( "keypress", function( e ) {
    if( e.which == 13 ) { 
      $( this ).parents( "form.instant" ).submit();
    }
    return true;
  } );

  /// TODO: focus on first input of instant form!
  $( "form.instant input:first" ).focus();


  $( ".bookmark" ).live( "click", function() {
    /// TODO
  } );

  $( "#bookmarks table tr:odd, #registrations table tr:odd" ).addClass( "odd" );

  $( ".chapter-controls" ).hide();

  $( ".chapter" ).hover(
    function() { $( this ).find( ".chapter-controls" ).show(); },
    function() { $( this ).find( ".chapter-controls" ).hide(); }
  );

  // $( ".tango-controls" ).hide();

  $( ".tango" ).hover( 
    function() { 
      $( ".spoiler:not(.bookmarks .spoiler)" ).addClass( "visible" );
      $( ".tango-controls" ).show();
    },
    function() { 
      $( ".spoiler:not(.bookmarks .spoiler)" ).removeClass( "visible" ); 
      $( ".tango-controls" ).hide();
    }
  );

  $( ".toggle" ).click( function() {
    var $toggleClass = $( this ).additionalClass( [ "kanji", "kana", "meaning" ] );
    $( ".bookmarks ." + $toggleClass ).toggleClass( "spoiler" );
  } ).hover(
    function() { 
      var $toggleClass = $( this ).additionalClass( [ "kanji", "kana", "meaning" ] );
      $( ".bookmarks ." + $toggleClass ).addClass( "selected-column" );
    },
    function() {
      var $toggleClass = $( this ).additionalClass( [ "kanji", "kana", "meaning" ] );
      $( ".bookmarks ." + $toggleClass ).removeClass( "selected-column" );
    } 
  );

  $( ".search-tango" ).click( function() {
    $bookmarked = $( this ).find( ".search-bookmarked" );
    $bookmarked.html(
      "<img src='/images/loader.gif' alt='' />"
    );
    $.getJSON( "/bookmark/" + $( this ).attr( "name" ) + "/toggle", 
	       function( data ) { 
		 $bookmarked.html( data == 'Created' ? "<img src='/images/heart.png' class='icon' alt=''>" : "" );
	       }
	     );
  } );
  
} );
