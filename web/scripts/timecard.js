/*
 * Author: Steven Sell
 * Dignitas Technologies (http://www.dignitastechnologies.com/)
 */

var day = new Date( ).getDay( );
var dayCount = new Array( 12 );

var count = -1;
var descHidden = 1;
var threshold = 0;

var days = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri" ];
var takenValues = new Array( );

var last_saturday = new Array( 3 );
var in_current_week = true;

var badrow = false;
var submitTheSheet = true;

// Date.getDay returns a value 0 - 6 with 0 being Sunday.
// I need 0 to be Saturday. So increment all by 1 except
// for Saturday which is set to 0.
day = day < 6 ? day + 1 : 0;

//------------------------------------------------------------------------------------------

function updateRowAddRemove( )
{
    var add = '<div id="TimeGrid_Add" style="width:16px;height:16px;margin:0;padding:0;border:0;background-color:transparent;background-image:url(\'images/icons/active/action_add.png\');background-repeat:no-repeat;float:left;cursor:pointer;"></div>'
    var rem = '<div id="TimeGrid_Remove" style="width:16px;height:16px;margin:0;padding:0;border:0;background-color:transparent;background-image:url(\'images/icons/active/action_delete.png\');background-repeat:no-repeat;float:left;cursor:pointer;"></div>';

    if( $( "#TimeGrid_Add" ).length > 0 )
    {
        $( "#TimeGrid_Remove" ).remove( );
        $( "#TimeGrid_Add" ).remove( );
    }

    $( "#task_row" + count ).children( ":first" ).html( ( count > threshold ? add + rem : add ) );

    $( '#TimeGrid_Add' ).bind( 'click', function( )
    {
        addRow( );

        //----------------------------------------------------------------------------------
        // Do not allow row to use a previously taken value

        var i = 0;
        var id = '#billable' + count;
        var value;

        for( ; i < count; i++ )
        {
            // Only prevent the task from being used if the task is already in use
            if( $( '#billable' + i ).attr( 'disabled' ) == 'true' )
            {
                value = $( '#billable' + i + ' option:selected' ).val( );
                $( id + ' option[value="' + value + '"]' ).remove( );
            }
        }

        $( id ).attr( 'style', 'width:100%;' );
    } );

    $( '#TimeGrid_Remove' ).bind( 'click', function( )
    {
        if( count > threshold )
        {
            $( '#task_row' + count ).remove( );
            count--;
            updateRowAddRemove( );
        }
    } );

}

//------------------------------------------------------------------------------------------

function setVisibleWeek( )
{
    var monthStr = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ];
    var mm;
    var dd;
    var yy;

    yy = last_saturday[ 0 ];
    mm = monthStr[ ( last_saturday[ 1 ] - 1 ) ];
    dd = last_saturday[ 2 ];

    if( dd < 10 )
        dd = '0' + dd;

    $( "#visible_week" ).html( mm + " " + dd + ", " + yy );
}

// Checks if the current Timecard displayed is for the current week
function weekIsCurrent( )
{
    var today = new Date( );
    var dd = today.getDate( );
    var mm = today.getMonth( ) + 1;
    var yyyy = today.getFullYear( );
 
    // Is today Saturday?
    if( day != 0 )
    {
        // Get what day Saturday was on
        dd = dd - day;

        // Oops, Saturday was in the previous month
        if( dd < 1 )
        {
            mm = mm - 1;

            // Did we go back into the previous year?
            if( mm == 0 )
            {
                mm = 12;
                yyyy = yyyy - 1;
            }

            // How many days in the month?
            if( mm == 1 || mm == 3 || mm == 5 || mm == 7 || mm == 8 || mm == 10 || mm == 12 )
                dd = 31 - dd;
            else if( mm == 2 )
            {
                // Leap year?
                if( yyyy % 4 == 0 )
                    dd = 29 - dd;
                else
                    dd = 28 - dd;
            }
            else
                dd = 30 - dd;
        }
    }

    if( dd < 10 ) 
        dd = '0' + dd;
  
    if( mm < 10 )
        mm = '0' + mm;

    // We FINALLY have the date of real last saturday
    // If last_sat is equal to the contents of #week_start then we are in the current week
    var reported_sat = $( "#week_start" ).html( );
     
    if( ( yyyy + "-" + mm  + "-" + dd ) != reported_sat )
        in_current_week = false;

}

function setDayCount( )
{
    for( var i = 0; i < 12; i += 1 )
    {
        if( i == 0 || i == 2 || i == 4 || i == 6 || i == 7 || i == 9 || i == 11 )
            dayCount[ i ] = 31;
        else if( i == 1 )
            dayCount[ i ] = last_saturday[ 0 ] % 4 == 0 ? 29 : 28;
        else
            dayCount[ i ] = 30;
    }
}


// Updates the last_saturday values to the current week (done on page load and when moving to another week)
function updateLastSaturday( )
{
    var dateStr = $( "#week_start" ).html( );

    last_saturday[ 0 ] = parseInt( dateStr.substr( 0, 4 ) );
    last_saturday[ 1 ] = parseInt( dateStr.substr( 5, 2 ) );
    last_saturday[ 2 ] = parseInt( dateStr.substr( 8, 2 ) );
}

// Calculates the totals for the 'total' row.
// Sums up every column and displays the total.
function calcTotals_Row( columnNumber )
{
    // if columnNumber == -1, then calculate totals for all columns
    // else, get total for only specified column (0-6 -> sat-fri)
    if( columnNumber == -1 )
    {
        for( var i = 0; i < 8; i++ )
            calcTotals_RowInd( i );
    }
    else
        calcTotals_RowInd( columnNumber );
}

function calcTotals_RowInd( columnNumber )
{
    var total = 0;
    
    // column 7 is the total column
    if( columnNumber != 7 )
    {
        var temp;
        
        // For each duration_disabled button in this column...
        //$( 'input[id*="duration_disabled_' + days[ columnNumber ] + '"]' ).each( function( )
        //{            
            // If there is a value in the button...
        //    if( $( this ).val( ).length > 0 )
        //    {
                // Ensure it is a valid number (it should always be valid, but just in case)
        //        temp = parseFloat( $( this ).val( ) );

        //        if( validateInput( temp ) )
        //            total += temp;
        //    }
            
        //} );
        
        // Now check any input text-boxes in this column...

        $( 'input[id*="duration_' + days[ columnNumber ] + '"]' ).each( function( )
        {
            if( $( this ).val( ).length > 0 )
            {
                temp = parseFloat( $( this ).val( ) );

                if( validateInput( temp ) )
                    total += temp;

            }
        } );   
       
        if( total > 0 ) 
            $( '#' + days[ columnNumber ] + '_totals' ).html( total );
    }
    else
    {
        for( var i = 0; i < 7; i++ )
        {
            total += parseFloat( $( '#' + days[ i ] + '_totals' ).html( ) );
        }
       
        if( total > 0 ) 
            $( '#Total_totals' ).html( total );
    }
}

//------------------------------------------------------------------------------------------

// Calculates the totals for the 'total' column.
// Sums up every row and displays the total.
function calcTotals_Col( rowNumber )
{
    if( rowNumber == -1 )
    {
        for( var i = 0; i < count + 1; i++ )
            calcTotals_ColInd( i );
    }
    else
        calcTotals_ColInd( rowNumber );
}

function calcTotals_ColInd( rowNumber )
{
    var total = 0;
    var temp;
    
    for( var i = 0; i < 7; i++ )
    {
        // If the text-box is being hidden...
       // if( $( '#duration_' + days[ i ] + rowNumber ).hasClass( 'hide_me' ) == true )
        //    temp = $( '#duration_' + days[ i ] + rowNumber ).html( );
       // else
            temp = $( '#duration_' + days[ i ] + rowNumber ).val( );
        
        if( temp != null && temp.length > 0 )
        {
            temp = parseFloat( temp );

            if( validateInput( temp ) )
                total += temp;
        }
    }
    
    $( '#task_total' + rowNumber ).html( total );
}

//------------------------------------------------------------------------------------------

function setHeaders( )
{
    $( '#TimeGrid' ).find( 'thead' ).find( 'tr' ).children( ).each( function( index )
    {
        // index - 1 to account for 'Task Name' being counted
        if( ( index - 1 ) == day && in_current_week )
            $( this ).addClass( 'alternate_header' );
        else
            $( this ).addClass( 'standard_header' );
    } );
}

//------------------------------------------------------------------------------------------

function addRow( )
{
    count++;
    
    var $clone = $( '#task_row' ).clone( );
    $clone.removeClass( "hide_me" );
 
    $clone.attr( 'id', 'task_row' + count );
    
    $clone.children( ).each( function( index )
    {
        $( this ).attr( 'id', $( this ).attr( 'id' ) + count );
        
        //Append number to child field
        $( this ).children( ).each( function( )
        {
            $( this ).attr( 'id', $( this ).attr( 'id' ) + count );
        } );
    
        //Enable the field if it is the correct day
        if( ( index - 1 ) == day )
        {
            //I don't like this way but it is the only way that works...
            $( this ).children( ).each( function( ){ $( this ).removeAttr( 'disabled' ); } );
        }
    } );
    
    if( count != 0 )
        $clone.insertAfter( $( '#task_row' + ( count - 1 ) ) );
    else
        $clone.insertAfter( $( '#task_row' ) );
    
    calcTotals_Row( -1 );
    calcTotals_Col( -1 );
        
    // Update totals when an input text box loses focus
    $( $clone ).keyup( function( )
    {
        calcTotals_Row( -1 );
        calcTotals_Col( -1 );
    } );

    updateRowAddRemove( );
}

//------------------------------------------------------------------------------------------

function validateInput( input )
{
    return !isNaN( parseFloat( input ) ) && isFinite( input );
}

//------------------------------------------------------------------------------------------

function getCellDay( id )
{
    if( id.indexOf( 'Sat' ) > -1 )
        return 0;
    else if( id.indexOf( 'Sun' ) > -1 )
        return 1;
    else if( id.indexOf( 'Mon' ) > -1 )
        return 2;
    else if( id.indexOf( 'Tue' ) > -1 )
        return 3;
    else if( id.indexOf( 'Wed' ) > -1 )
        return 4;
    else if( id.indexOf( 'Thu' ) > -1 )
        return 5;
    else
        return 6;
}

//------------------------------------------------------------------------------------------

function bind( )
{
    $( '.errorButton' ).bind( 'click', function( )
    {
        event.preventDefault( );
        
        // If no more errors, hide the error box
        if( $( "#errorMessages button" ).length == 1 )
            $( "#errorMessages" ).addClass( 'hide_me' );
        
        $( this ).remove( );        
    } );
}

//------------------------------------------------------------------------------------------

//
//      CLEAN ME UP!
//
function makeForm( billableElement, durationElement, index )
{
    var billable    = $( '#' + billableElement ).clone( );
    var duration    = $( '#' + durationElement ).clone( ); 
    var descript    = $( '#description' ).clone( );
    var date        = $( '#date' ).clone( );
    var week        = $( '#week' ).clone( );
    var remoteUser  = $( '#remote_user_original' ).clone( );
    var remoteAddr  = $( '#remote_address_original' ).clone( );

    // Set proper dates
    week.html( last_saturday[ 0 ] + "-" + ( last_saturday[ 1 ] < 10 ? '0' + last_saturday[ 1 ] : last_saturday[ 1 ] ) + "-" + ( last_saturday[ 2 ] < 10 ? '0' + last_saturday[ 2 ] : last_saturday[ 2 ] ) );

    var mapping = new Object;
          
    mapping.Sat = 0;
    mapping.Sun = 1;
    mapping.Mon = 2;
    mapping.Tue = 3;
    mapping.Wed = 4;
    mapping.Thu = 5;
    mapping.Fri = 6;

    var dur_date = durationElement.substr( 9, 3 );

    if( mapping[ dur_date ] != 0 )
    {
         var yy = last_saturday[ 0 ];
         var mm = last_saturday[ 1 ];
         var dd = last_saturday[ 2 ] + mapping[ dur_date ];

         if( dd > dayCount[ mm - 1 ] )
         {
             if( mm == '12' )
                 yy += 1;
                   
             dd = dd - dayCount[ mm - 1 ];
             mm = mm == 12 ? 1 : mm + 1;
         }

         dd = dd < 10 ? '0' + dd : dd;
         mm = mm < 10 ? '0' + mm : mm;

         date.val( yy + '-' + mm + '-' + dd );
     }
     else
         date.val( last_saturday[ 0 ] + '-' + last_saturday[ 1 ] + '-' + last_saturday[ 2 ] );

    //-------------------------------------------------------------------------------------- 
    
    week.removeAttr( 'type' );
    date.removeClass( 'hide_me' );
    billable.removeAttr( 'disabled' );
    remoteUser.removeAttr( 'id' );
    remoteAddr.removeAttr( 'id' );
    
    date.attr( 'id', 'date_' + index );
    
    // Generate a unique iframe for this form to submit into
    $( '<iframe>' ).attr(
    {
        id: 'take_the_punch' + index,
        name: 'take_the_punch'  + index
    } ).appendTo( '#formHolder' );

    // Generate the actual form    
    $( '<form>' ).attr(
    {
        id: 'activeForm' + index,
        name: 'activeForm' + index,
        action: 'timecard',
        method: 'post',
        target: 'take_the_punch' + index
    } ).appendTo( '#formHolder' );
   
    billable.attr( 'name', "billable_task" );
    duration.attr( 'name', 'duration' );
    descript.attr( 'name', 'description' );
    
    billable.val( $( '#' + billableElement ).val( ) );
  
    // If we are editing a previous time entry 
    if( duration.hasClass( "pre_existing" ) )
    {
        // Date
        $( '<input>' ).attr(
        {
            type: 'hidden',
            name: 'date',
            id: 'date_' + index,
            value: date.val( )
        } ).appendTo( '#activeForm' + index );

        // Employee
        $( '<input>' ).attr(
        {
            type: 'hidden',
            name: 'employee',
            value: $( "#employee_param" ).html( ),
            id: 'employee_' + index
        } ).appendTo( '#activeForm' + index );

        // Task
        $( '<input>' ).attr( 
        {
            type: 'hidden',
            name: 'task',
            value: billable.val( ),
            id: 'task_' + index
        } ).appendTo( '#activeForm' + index );

        // Duration and Description
        duration.attr( "id", "duration_" + index );
        descript.attr( "id", "descript_" + index );

        $( "#activeForm" + index ).append( duration );
        $( "#activeForm" + index ).append( descript );
        $( "#activeForm" + index ).append( remoteUser );
        $( "#activeForm" + index ).append( remoteAddr );

        // Reason 
        $( '<input>' ).attr(
        {
            type: 'text',
            name: 'reason', 
            id: 'reason_' + index,
            value: ( $( "#modifyField" ).length > 0 ? ( $( "#modifyField" ).hasClass( "hide_me" ) ? "Same week modification" : $( "#modifyArea" ).val( ) ) : "none" )
        } ).appendTo( '#activeForm' + index );

        // Submission Type
        $( '<input>' ).attr(
        {
            type: 'hidden',
            name: 'requestType',
            value: 'modify_entry'
        } ).appendTo( '#activeForm' + index );

        // Submit button
        $( '<input>' ).attr( 
        {
            type: 'submit',
            name: 'modifyEntry',
            id: 'activeInput' + index,
            value: 'Modify'
        } ).appendTo( '#activeForm' + index );

    }
    else // A brand new time entry
    {    
        $( '#activeForm' + index ).append( date );
        $( '#activeForm' + index ).append( week );
        $( '#activeForm' + index ).append( billable );
        $( '#activeForm' + index ).append( duration );
        $( '#activeForm' + index ).append( descript );

        // Employee
        $( '<input>' ).attr(
        {
            type: 'hidden',
            name: 'employee',
            value: $( "#employee_param" ).html( ),
            id: 'employee_' + index
        } ).appendTo( '#activeForm' + index );

        $( '<input>' ).attr( 
        {
            type: 'hidden',
            name: 'requestType',
            value: 'new_entry'
        } ).appendTo( '#activeForm' + index );

        $( '<input>' ).attr(
        {
            type: 'submit',
            name: 'recordTime',
            id: 'activeInput' + index,
            value: 'Record'
        } ).appendTo( '#activeForm' + index );
    }
}

//------------------------------------------------------------------------------------------

function removeForms( )
{
    $( '#formHolder' ).empty( );
}

//------------------------------------------------------------------------------------------

$( document ).ready( function( )
{
    updateLastSaturday( );
    weekIsCurrent( );
    setDayCount( );
    setVisibleWeek( );

//    bind( );
    
    // Make sure the TimeGrid ID is being used.
    // Check the length because the selector will always return
    // an object (empty one if DNE) and thus if($('#Name'))
    // will always return true.
    if( $( '#TimeGrid' ).length > 0 )
    {
        //First set the appropriate header styles
//        setHeaders( );
        
        //If there is data already, fill out the grid
        fillGrid( );
        
        //Add the initial row
        //But only if there isn't already a row visible
        if( $( '#task_row0' ).length == 0 )
            addRow( );   
        
        calcTotals_Row( -1 );
        calcTotals_Col( -1 );
        
        // Do not allow user to remove a row that has saved data in it2
        threshold = count;

        // Quick, dirty solution to remove row button appearing on a preloaded row on first page load
        $( "#TimeGrid_Remove" ).remove( );

        for( var i = 0; i < count + 1; i++ )
            if( $( "#billable" + i ).val( ) != "..." ) $( "#billable" + i ).attr( "disabled", "true" );

        if( ( last_saturday[ 0 ] + "-" + ( last_saturday[ 1 ] < 10 ? '0' + last_saturday[ 1 ] : last_saturday[ 1 ] ) + "-" + ( last_saturday[ 2 ] < 10 ? '0' + last_saturday[ 2 ] : last_saturday[ 2 ] ) ) != $( "#true_week" ).html( ) )
        {
            if( $( "#modifyField" ).length > 0 )
            {
                $( "#saveButton" ).css( "margin-top", "15px" );
                $( "#modifyField" ).removeClass( "hide_me" );
            }
        }
    }
    
    //--------------------------------------------------------------------------------------
    // Updating grid with data from the base
            
    function getRowNumber( taskName )
    {
        var i = 0;
        
        for( i = 0; i <= count; i++ )
        {
            // Iterate through all 'billable#'s (drop-downs) and check current value
            // If the value contains the task name, this is the row we want
            // to insert into.
            if( $( '#billable' + i + ' option:selected' ).text( ).indexOf( '(' + taskName ) != -1 )
                return i;
        }
        
        //Row not found
        return -1;
    }
    
    function fillCells( dayName )
    {
        var rowNumber;
        
        // If DELETE_ME holds data from the database for this day
        if( $( '#' + dayName ).length > 0 )
        {
            // For each packet of data for that day...
            $( '#DELETE_ME' ).find( '#' + dayName ).each( function( index )
            {
                // Does there already exist a row that holds data of the same task?
                rowNumber = getRowNumber( $( this ).find( '#taskNumba' ).html( ) );
                
                // No row. Make a new one 
                if( rowNumber == -1 )
                {
                    addRow( );
                    rowNumber = count;
                }
                
                $( '#billable' + rowNumber ).val( $( this ).find( '#taskNumba' ).html( ) );
                $( '#duration_' + dayName + rowNumber ).val( $( this ).find( '#durate' ).html( ) );
                $( '#duration_' + dayName + rowNumber ).addClass( "pre_existing" );
                
                // We want to mark this value as taken so future rows can not use it as their task.
                // is value is in takenValue? -1 means it is not
                if( $.inArray( $( '#billable' + rowNumber ).val( ), takenValues ) == -1 )
                    takenValues[ takenValues.length ] = $( '#billable' + rowNumber ).val( );
                
            } );
        }
        else
            $( '#DELETE_ME' ).append( dayName + ' ! ' );
    }
    
    function fillGrid( )
    {
        var i = 0;
        
        for( i = 0; i < 7; i++ )
        {
            fillCells( days[ i ] );
        }
    }
    
    //--------------------------------------------------------------------------------------
    // Button Handling
    
    $( '#TimeGrid_Add' ).bind( 'click', function( )
    {
        
        //----------------------------------------------------------------------------------
        // Do not allow row to use a previously taken value
        
        var i = 0;
        var id = '#billable' + count;
        var value;
        
        for( ; i < count; i++ )
        {
            // Only prevent the task from being used if the task is already in use
            if( $( '#billable' + i ).attr( 'disabled' ) == 'true' )
            {
                value = $( '#billable' + i + ' option:selected' ).val( );            
                $( id + ' option[value="' + value + '"]' ).remove( );
            }
        }
        
        $( id ).attr( 'style', 'width:100%;' );
    } );
    
    $( '#TimeGrid_Remove' ).bind( 'click', function( )
    {
        if( count > threshold )
        {
            $( '#task_row' + count ).remove( );
            count--;
            updateRowAddRemove( );
        }
    } );
    
    $( '#descriptionButton' ).bind( 'click', function( )
    {
        if( descHidden == 1 )
        {
            $( '#description' ).removeClass( 'hide_me' );
            descHidden = 0;
        }
        else
        {
            $( '#description' ).addClass( 'hide_me' );
            descHidden = 1;
        }
    } );
    
    //--------------------------------------------------------------------------------------
    
    $( "#saveButton" ).bind( 'click', function( )
    {
        if( $( this ).hasClass( 'saveButton_disabled' ) )
            return;

        var billable, duration;
        var cnt = 0;
        var ind = new Array( );

        submitTheSheet = true;
        
        if( !$( "#modifyField" ).hasClass( "hide_me" ) )
        {
            if( $( "#modifyArea" ).val( ).length == 0 )
            {
                $( "#modifyField" ).css( "background-color", "#D97D71" );
                setTimeout( function( ){ $( "#modifyField" ).css( "background-color", "#D9B6AF" ); setTimeout( function( ){ $( "#modifyField" ).css( "background-color", "#FFFFFF" ); }, 100 ); }, 100 );

                submitTheSheet = false;
                return;
            }
        }

        badrow = false;

        $( '.duration_input' ).each( function( index )
        {
            if( $( this ).attr( 'id' ).length > 12 )
            {
                if( $( this ).val( ).length > 0 && validateInput( $( this ).val( ) ) )
                {
                    // Make sure task has been specified
                    billable = $( "#billable" + ( $( this ).attr( 'id' ).substr( 12 ) ) );

                    if( billable.val( ) != "..." )
                    {
                        makeForm( billable.attr( 'id' ), $( this ).attr( 'id' ), index );

                        ind[ cnt ] = index;
                        cnt++;
                    }
                    else
                    { 
                        billable.css( "background-color", "#D97D71" );
                        setTimeout( function( ){ billable.css( "background-color", "#D9B6AF" ); setTimeout( function( ){ billable.css( "background-color", "#FFFFFF" ); }, 100 ); }, 100 );
                        badrow = true;
                        return;
                    }
                }
            }
        } );

        if( badrow )
        {
            submitTheSheet = false;
            return;
        }

        for( var i = 0; i < cnt; i++ )
            $( "#activeInput" + ind[ i ] ).trigger( 'click' );

        setTimeout( function( ){ $( "#refresh_week" ).trigger( 'click' ); }, 1500 );

        submitTheSheet = true;
    } );
    
    $( '#submitButton' ).bind( 'click', function( )
    {
        $( '#saveButton' ).trigger( 'click' )

        if( submitTheSheet )
            $( '#submitReal' ).trigger( 'click' );
    } );
    
    $( '#retractButton' ).bind( 'click', function( )
    {
        $( '#retractReal' ).trigger( 'click' );

        setTimeout( function( ){ $( "#refresh_week" ).trigger( 'click' ); }, 300 );
    } );   

    //--------------------------------------------------------------------------------------
    
    // For each id containing 'duration'
    $( 'input[id*="dduration"]' ).each( function( index )
    {   
        // Are we in current week? (did not go back or forth)
        if( in_current_week )
        {
            // If the id contains the current day
            if( $( this ).attr( 'id' ).indexOf( days[ day ] ) >= 0 )
            {
                // And if there is no value in the element
                if( $( this ).val( ).length  == 0 )
                {
                    // This element can be edited freely
                    $( this ).addClass( 'duration_enabled' );
                    return true;               
                }
            }
        }

        // Otherwise, disable the element
        $( this ).addClass( 'hide_me' );
        
        // Create a button that, when clicked, opens up the edit page in an overlay
        var parent = $( this ).parent( );
        var trueDay = $( this ).attr( 'id' ).substring( 9, 12 );
        var id = index < 77 ? 'duration_disabled_' + trueDay + parent.attr( 'id' ).substr( parent.attr( 'id' ).length - 1 ) : 'duration_disabled_' + trueDay + parent.attr( 'id' ).substr( parent.attr( 'id' ).length - 2 ) + parent.attr( 'id' ).substr( parent.attr( 'id' ).length - 1 );
        
        var overlayToUse;
        var className;
        
        // If there is a value contained within the element
        if( $( this ).val( ).length  > 0 )
        {    
            overlayToUse = '#overlay';
            className = "external";
            
            //Do not allow user to change task that already has saved data
            parent.parent( ).children( ':first' ).children( ':first' ).attr( 'disabled', 'true' );
        }
        else
        {
            overlayToUse = '#overlay_native';
            className = "native";
        }
        
        parent.append( '<a rel="' + overlayToUse + '" class=".' + className +'" style="text-decoration:none"><button type=\"button\" id=\"' + id + '\" class=\"duration_disabled\" style=\"width:85px;height:100%">' + $( this ).val( ) + '</button></a>' );
   
        if( in_current_week ) 
        {
            if( $( this ).attr( 'id' ).indexOf( days[ day ] ) >= 0 )
            {
                $( '#' + id ).removeClass( 'duration_disabled' );
                $( '#' + id ).addClass( 'duration_enabled' );
            }
        }
        
        // Fix for Firefox displaying empty buttons with dimensions different from those with text.
        // Forcing 100% height with !important provides the correct height, but then the alignment is off.
        if( $( this ).val( ).length == 0 )
        {
            $( '#' + id ).css( 'color', '#EEE' );
            $( '#' + id ).append( '.' );
        }
    } );
    
    //--------------------------------------------------------------------------------------
    
    $( 'button[id*="dduration_disabled_"]' ).bind( 'click', function( )
    {
        var reveal = $( this ).parent( ).attr( 'rel' );
     
        updateLastSaturday( );
   
        if( reveal == "#overlay" )
        {
            // The proper edit URL is already calculated and hidden away
            // Need to first construct the id of the span that contains the url.
            var spanName = $( this ).attr( 'id' ).substring( 18, 21 );

            spanName += "_task";

            spanName += $( this ).parent( ).parent( ).parent( ).children( ':first' ).children( ':first' ).val( );

            var url = $( '#' + spanName ).html( );

            $( this ).parent( ).attr( 'href', url );
            $( this ).parent( ).attr( 'href', $( this ).parent( ).attr( 'href' ).replace( "amp;", "" ) );
            $( this ).parent( ).attr( 'href', $( this ).parent( ).attr( 'href' ).replace( "amp;", "" ) );
            
            $( '#displayEdit' ).attr( 'src', $( this ).parent( ).attr( 'href' ) );
        }
        else
        {
            var yyyy = last_saturday[ 0 ];
            var mm   = last_saturday[ 1 ];
            var dd   = last_saturday[ 2 ];
            
            // Set day to the cell clicked
            dd = dd + getCellDay( $( this ).attr( 'id' ) );
            
            // Ensure did not exceed the bounds of the month
            if( dd > dayCount[ mm - 1 ] )
            {
                if( mm == '12' )
                    yyyy += 1;

                dd = dd - dayCount[ mm - 1 ];
                mm = mm == 12 ? '1' : mm + 1;
            }
            
            dd = dd < 10 ? '0' + dd : dd;
            mm = mm < 10 ? '0' + mm : mm;

            $( "#newEntryDate" ).attr( "value", ( yyyy + "-" + mm + "-" + dd ) );
            
            // Set task
            var taskId = $( this ).parent( ).parent( ).parent( ).children( ':first' ).children( ':first' ).attr( 'id' );
            $( '#newEntryTask' ).html( $( '#' + taskId + ' option:selected' ).text( ) ); 
            $( '#select_name' ).html( taskId );
        }
        
        $( reveal ).removeClass( 'hide_me' );

        // Give the iFrame some time to populate before querying its elements
        setTimeout( function( )
        {
            $( "#submit_edit_sheet", frames[ 'displayEdit' ].document ).submit( function( )
            {
                // Give the form time to actually submit before closing the window
                setTimeout( function( )
                {
                    $( "#closeEditButton" ).trigger( 'click' );
                    $( "#refresh_week" ).trigger( 'click' );
                }, 300 );
            } );
        }, 500 );
    } );
    
    //--------------------------------------------------------------------------------------
    
    $( '#newEntrySubmit' ).bind( 'click', function( )
    {
        var message = new Array( );
        var count = -1;
        
        if( $( '#newEntryDuration' ).val( ).length == 0 )
        {
            count++;
            message[ count ] = 'A Duration is Required';
        }
        else 
        {
            if( validateInput( $( '#newEntryDuration' ).val( ) ) == false )
            {
                count++;
                message[ count ] = 'Invalid Value for Duration';
            }
            else if( $( '#newEntryDuration' ).val( ) > 24 )
            {
                count++;
                message[ count ] = 'Duration May Not Exceed 24 Hours';
            }
            else if( $( '#newEntryDuration' ).val( ) < 0 )
            {
                count++;
                message[ count ] = 'A Positive Duration is Required';
            }
        }
        
        if( $( '#newEntryDescription' ).val( ) <= 0 )
        {
            count++;
            message[ count ] = 'A Description is Required';
        }
        
        // There were errors. Report them.
        if( count != -1 )
        {
            $( '#errorMessages' ).removeClass( 'hide_me' );
            
            var i = 0;
            
            for( i; i <= count; i++ )
                $( '#errorMessages' ).append( '<button type="button" class="errorButton"><span style="color:#FFF;font-family:Georgia,serif;"><b>x</b></span> ' + message[i] + '</button>' );
            
            bind( );
        }
        else
        {   
            var date = $( '#newEntryDate' );
            var duration =  $( '#newEntryDuration' );
            var description = $( '#newEntryDescription' );
            var select = $( '#' + $( '#select_name' ).html( ) );
            
            //------------------------------------------------------------
            
            $( '#date' ).removeAttr( 'name' );
            date.attr( 'name', 'date' );
            date.removeAttr( 'disabled' );
            
            duration.attr( 'name', 'duration' );
            
            description.attr( 'name', 'description' );
            $( '#description' ).removeAttr( 'name' );
            
            select.attr( 'name', 'billable_task' );
            select.removeAttr( 'disabled' );
            
            //------------------------------------------------------------
            // Submit form
            
            $( '#newEntryTrueSubmit' ).attr( 'name', 'recordTime' );
            $( '#newEntryTrueSubmit' ).trigger( 'click' );
            $( '#newEntryTrueSubmit' ).removeAttr( 'name' );
            
            //------------------------------------------------------------
            
            $( '#date' ).attr( 'name', 'date' );
            date.removeAttr( 'name' );
            date.attr( 'disabled', 'true' );
            
            duration.removeAttr( 'name' );
            
            description.removeAttr( 'name' );
            $( '#description' ).attr( 'name', 'description' );
            
            select.removeAttr( 'name' );
            select.attr( 'disabled', 'true' );

            //------------------------------------------------------------

            // Close form and refresh page
            setTimeout( function( )
            {
                $( "#closeEditButton" ).trigger( 'click' );
                $( "#refresh_week" ).trigger( 'click' );
            }, 300 );
        }
    } );
    
    //--------------------------------------------------------------------------------------

    // Ensure that the duration ends with .00, .25, 0.50, or 0.75
    $( ".duration_enabled,#newEntryDuration" ).blur( function( )
    {
        var dur = $( this ).val( );

        if( dur.length > 0 )
        {
           // illegal value in duration
           if( !validateInput( dur ) )
           {
               $( this ).val( "" );
           } 
           else
           {
               dur = dur * 100;

               // make sure only two decimal places
               if( dur % 1 != 0 )
                  dur = Math.ceil( dur );

               // crappy rounding method
               while( dur % 25 != 0 )
                   dur += 1;

               $( this ).val( ( dur / 100 ) );

               // update total displays
               if( $( this ).attr( "id" ) != "newEntryDuration" )
               {
                   calcTotals_Row( -1 );
                   calcTotals_Col( -1 );
               }
           }
        }
    } );

    //--------------------------------------------------------------------------------------
 
    $( "a[rel='#overlay']" ).overlay(
    {
        mask: 'white',

        onBeforeLoad: function( )
        {
            var wrap = this.getOverlay( ).find( ".contentWrap" );

            wrap.load( this.getTrigger( ).attr( "href" ) );
        },
        
        closeOnClick: false
    } );
    
    $( "a[rel='#overlay_native']" ).overlay( { mask: 'white', closeOnClick: false } );
 
    //--------------------------------------------------------------------------------------

    $( "#prevWeekButton" ).bind( 'click', function( ){ $( "#prev_week" ).trigger( 'click' ); } );
    $( "#nextWeekButton" ).bind( 'click', function( ){ $( "#next_week" ).trigger( 'click' ); } );
    $( "#todayButton" ).bind( 'click', function( ){ $( "#return_to_today" ).trigger( 'click' ); } );
} );
