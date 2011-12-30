function bind( )
{
    $( '.errorButton' ).bind( 'click', function( )
    {
        if( $( "#errorMessages button" ).length == 1 )
            $( '#errorMessages' ).addClass( 'hide_me' );
        
        $( this ).remove( );        
    } );
}

function validateInput( input )
{
    return !isNaN( parseFloat( input ) ) && isFinite( input );
}

$( document ).ready( function( )
{
    bind( );
    
    $( '#modify' ).bind( 'click', function( )
    {
        var message = new Array( );
        var count = -1;
        
        if( $( '#duration' ).val( ).length <= 0 )
        {
            count++;
            message[ count ] = 'A Duration is Required';
        }
        else
        {
            if( validateInput( $( '#duration' ).val( ) ) == false )
            {
                count++;
                message[ count ] = 'Invalid Value for Duration';
            }
            else if( $( '#duration' ).val( ) >24 )
            {
                count++;
                message[ count ] = 'A Positive Duration is Required';
            }
            else if( $( '#duration' ).val( ) < 0 )
            {
                count++;
                message[ count ] = 'A Positive Duration is Required';
            }
        }
        
        if( $( '#description' ).val( ) <= 0 )
        {
            count++;
            message[ count ] = 'A Description is Required';
        }
        
        if( $( '#reason' ).val( ) <= 0 )
        {
            count++;
            message[ count ] = 'A Reason for Modification is Required';
        }
        
        if( count != -1 )
        {
            $( '#errorMessages' ).removeClass( 'hide_me' );
            
            var i = 0;
            
            for( i; i <= count; i++ )
                $( '#errorMessages' ).append( '<button type="button" class="errorButton"><span style="color:#FFF;font-family:Georgia,serif;"><b>x</b></span> ' + message[i] + '</button>' );
            
            
            bind( );
        }
    } );
} );