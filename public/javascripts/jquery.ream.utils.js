//
//
//
//
//
( function( $ ) {

  function makeAttrs( attrs ) {
    var str = "";

    for( key in attrs ) {
      str += " " + key + "=\"" + attrs[ key ] + "\"";
    }

    return str;
  }

  function tag( name, attrs, content ) {
    var _tag = "<" + name;

    if( attrs ) {
      _tag += makeAttrs( attrs );
    }

    if( content ) {
      _tag += ">" + content + "</" + name + ">";
    } else {
      _tag += "/>";
    }

    return _tag;
  }

  function findFirst( array, callback ) {
    for( i in array ) {
      if( callback( array[ i ] ) ) { return array[ i ]; }
    }
    return null;
  }

  function findByType( array, type ) {
    return findFirst( array, function( value ) { return typeof( value ) == type; } );
  }

  $.fn.addMe = function( text ) {
    var node = $( text );
    $( this ).append( node );
    return node;
  };

  $.fn.tag = function( name, a1, a2 ) {
    var args = [ a1, a2 ];
    var content  = findByType( args, "string" );
    var attrs    = findByType( args, "object" );
    var callback = findByType( args, "function" );

    var node = $( this ).addMe( tag( name, attrs, content ) );
    if( callback ) { callback( node ); }
    return node;
  };

  $.fn.text = function( text ) {
    $( this ).append( text );
    return $( this );
  }

})( jQuery );
