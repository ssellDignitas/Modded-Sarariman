function bind_rows( )
{
    $( ".row" ).bind( 'click', function( )
    {     
        var parentID = $( this ).parent( ).attr( 'id' );
        var me = $( this );

        $( ".row_active, .row_edit" ).each( function( )
        {
            if( $( this ).parent( ).attr( 'id' ) == parentID && $( this ).html( ) != me.html( ) )
            {
                $( this ).removeClass( "row_edit" );
                $( this ).removeClass( "row_active" );
            }
        } );

        if( $( this ).hasClass( "row_active" ) )
        {
            // Element was, in essence, double-clicked
            $( this ).removeClass( "row_active" );
            $( this ).addClass( "row_edit" );

            var name = $( this ).children( ).eq( 0 ).html( );
            var html = "<input type='text' class='name_input' id='" + name + "'/>";

            $( this ).html( html );

            $( "#" + name ).val( name ); 
            $( "#" + name ).removeAttr( 'id' );

        }
        else if( $( this ).hasClass( "row_edit" ) )
        {
            $( this ).removeClass( "row_edit" );
            $( this ).html( "<span class='name'>" + $( this ).children( ).eq( 0 ).val( ) + "</span>" );
        }
        else
        {
            // First click on element.
            $( this ).addClass( "row_active" ); 
        }
    } ); 
}

function bind_customers( )
{
    $( ".customers" ).bind( 'click', function( )
    {
        if( $( this ).hasClass( "row_active" ) )
        {
            var name = $( this ).find( '.name' ).html( );
            var tasks = new Array( );

            // Toggle child projects
            $( ".projects" ).each( function( )
            {
                $( this ).removeClass( "hide_me" );

                if( $( this ).children( ).eq( 1 ).html( ) != name )
                    $( this ).addClass( "hide_me" );
                else
                    tasks.push( $( this ).children( ).eq( 0 ).html( ) );
            } );

            // Toggle child tasks
            $( ".tasks" ).each( function( )
            {
                $( this ).removeClass( "hide_me" );

                if( jQuery.inArray( $( this ).children( ).eq( 1 ).html( ), tasks ) == -1 ) 
                    $( this ).addClass( "hide_me" );
            } );
        }   
    } );
}

$( document ).ready( function( )
{
    bind_rows( );
    bind_customers( );
} );

