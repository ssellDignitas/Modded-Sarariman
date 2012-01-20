$(document).ready(function()
{
    //--------------------------------------------------------------------------------------
    // Append the proper form to the correct day pane

    var i = 0;
    var day = new Date().getDay();
    var pane = new Array(7);
    
    pane[0] = "sunday";
    pane[1] = "monday";
    pane[2] = "tuesday";
    pane[3] = "wednesday";
    pane[4] = "thursday";
    pane[5] = "friday";
    pane[6] = "saturday";
    
    var $clone;
    
    for( i = 0; i <= 6; i++ )
    {
        $( '#' + pane[i] ).empty();
        
        if( i == day )
        {
            $clone = $( '.currentForm' ).clone( );
            
            $clone.removeClass( 'currentForm' );
            $clone.attr( 'id', 'currentForm' );
            $clone.find( '.LHS_interior' ).attr( 'id', 'real_LHS' );
            $clone.appendTo( '#' + pane[i] );
        }
        else
        {
            $clone = $( '.lockedForm' ).clone( );
            
            $clone.removeClass( 'lockedForm' );
            $clone.appendTo( '#' + pane[ i ] );
        }
    }
    
    //######################################################################################
    
    // Make sure the appropriate pane is displayed by default.
    
    var tabAPI = $( 'ul.tabs' ).data( 'tabs' );
    var index = day < 6 ? day + 1 : 0;
    
    tabAPI.click( index );
    
    //######################################################################################
    
    // Handle button clicks and the initial charge/duration fields
    
    var number = -1;
    
    function appendFields()
    {
        number++;

        var $clone = $( '.currentFormTemplate' ).clone();

        $clone.removeClass( 'currentFormTemplate' );
        $clone.attr( "id", "currentFormHolder" + number );

        //Update the ids for the copied elements
        $clone.find( '#billable' ).attr( "id", "billable_task" + number );
        $clone.find( '#duration' ).attr( "id", "duration" + number );

        $clone.appendTo( '#real_LHS' );
    }
    
       
    //--------------------------------------------------------------------------------------
    // Add charges/durations

    $( '.addFields' ).bind( 'click', function()
    {
        appendFields();
    });

    //--------------------------------------------------------------------------------------
    // Remove charges

    $( '.removeFields' ).bind( 'click', function()
    {
        //Always have one visible
        if( number != 0 )
        {
            $( '#currentFormHolder' + number ).remove( );

            if( number >= 0 )
                number--;
        }
    });
    
    //--------------------------------------------------------------------------------------
    // Create the initial fields
    
    appendFields();
});