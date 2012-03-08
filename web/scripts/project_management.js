function bind_rows( )
{
    $( ".row" ).bind( 'click', function( )
    {     
        var parentID = $( this ).parent( ).attr( 'id' );
        var me = $( this );

        $( ".edit" ).each( function( ){ $( this ).addClass( "hide_me" ); } );

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
        }
        else if( $( this ).hasClass( "row_edit" ) )
        {
            $( this ).removeClass( "row_edit" );
            
            if( $( this ).hasClass( "customers" ) )
                $( ".projects" ).each( function( ){ $( this ).removeClass( "hide_me" ); $( this ).removeClass( "row_active" ); } );

            if( !$( this ).hasClass( "tasks" ) )
                $( ".tasks" ).each( function( ){ $( this ).removeClass( "hide_me" ); $( this ).removeClass( "row_active" ); } );
        }
        else
        {
            // First click on element.
            $( this ).addClass( "row_active" ); 
        }
      
        if( !$( this ).hasClass( "row_edit" ) )
            $( ".row_edit" ).each( function( ){ $( this ).removeClass( "row_edit" ); $( this ).addClass( "row_active" ); } )
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
                $( this ).removeClass( "row_active" );

                if( $( this ).children( ).eq( 1 ).html( ) != name )
                    $( this ).addClass( "hide_me" );
                else
                    tasks.push( $( this ).children( ).eq( 0 ).html( ) );
            } );

            // Toggle child tasks
            $( ".tasks" ).each( function( )
            {
                $( this ).removeClass( "hide_me" );
                $( this ).removeClass( "row_active" );

                if( jQuery.inArray( $( this ).children( ).eq( 1 ).html( ), tasks ) == -1 ) 
                    $( this ).addClass( "hide_me" );
            } );
        }
        else if( $( this ).hasClass( "row_edit" ) )
        {
            $( this ).next( ).removeClass( "hide_me" );
        }   
        else
        {
            $( this ).next( ).addClass( "hide_me" );
        }
    } );
}

function bind_projects( )
{
    $( ".projects" ).bind( 'click', function( )
    {
        if( $( this ).hasClass( "row_active" ) )
        {
            var name = $( this ).find( '.name' ).html( );
            
            $( ".tasks" ).each( function( )
            {
                $( this ).removeClass( "hide_me" );
                $( this ).removeClass( "row_active" );

                if( $( this ).children( ).eq( 1 ).html( ) != name )
                    $( this ).addClass( "hide_me" );
            } ); 
        }
        else if( $( this ).hasClass( "row_edit" ) )
        {
            $( this ).next( ).removeClass( "hide_me" );
        }
        else
        {
            $( this ).next( ).addClass( "hide_me" );
        }
    } );
}

function bind_tasks( )
{
    $( ".tasks" ).bind( 'click', function( )
    {
        if( $( this ).hasClass( "row_edit" ) )
        {
            $( this ).next( ).removeClass( "hide_me" );
        }
        else if( !$( this ).hasClass( "row_active" ) )
        {
            $( this ).next( ).addClass( "hide_me" );
        }
    } );
}

$( document ).ready( function( )
{
    bind_rows( );
    bind_customers( );
    bind_projects( );
    bind_tasks( );

    $( "button" ).bind( 'click', function( )
    {
        $( this ).parent( ).parent( ).find( 'form' ).submit( );
    } );
} );

