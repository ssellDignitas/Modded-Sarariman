/**
 * Sets each cell of the Admin/Approver/Manager columns to either a
 * 'yes' or 'no' class. This provides the distinction of if the given
 * employee has a privelaged role.
 *
 * The 'yes'/'no' classes are also used in set_aam_bindings to determine
 * the proper onClick behaviour of each cell of these columns.
 *
 * At the end, the container divs of who_is_admin/appr/mgr are removed
 * as they are no longer needed and thus serve no purpose for continuing
 * to exist inside of the DOM.
 */
function set_checks( )
{
    $( "#who_is_admin" ).children( ).each( function( )
    {
        $( "#" + $( this ).attr( "class" ) ).find( ".employee_is_admin" ).addClass( "yes" );
    } );

    $( "#who_is_appr" ).children( ).each( function( )
    {
        $( "#" + $( this ).attr( "class" ) ).find( ".employee_is_approver" ).addClass( "yes" );
    } );

    $( "#who_is_mgr" ).children( ).each( function( )
    {
        $( "#" + $( this ).attr( "class" ) ).find( ".employee_is_manager" ).addClass( "yes" );
    } );

    $( ".employee_is_admin,.employee_is_approver,.employee_is_manager" ).each( function( )
    {
        if( !$( this ).hasClass( "yes" ) )
            $( this ).addClass( "no" );
    } );

    $( "#who_is_admin" ).remove( );
    $( "#who_is_appr" ).remove( );
    $( "#who_is_mgr" ).remove( );
}

//------------------------------------------------------------------------------------------

function gen_form( add_remove, type, employee_num )
{
    $( "#form_holder" ).append( "<form id=\"temp_form\" method=\"POST\" action=\"employeeTableController\" target=\"target_frame\"></form>" );

    $( "#temp_form" ).append( "<input type='hidden' name='action' value='" + add_remove + "'/>" +
                              "<input type='hidden' name='table' value='" + type + "'/>" +
                              "<input type='hidden' name='employee' value='" + employee_num + "'/>" +
                              "<input type='submit' name='" + type + "' value='" + ( type == "add" ? "Add" : "Remove" ) + "'/>" );
}

/**
 * Sets the onClick behaviour of each cell of the Admin/Approver/Manager columns.
 *
 * If the clicked cell has the class 'yes', then the privelaged role is removed
 * after confirmation from the user.
 *
 * Else if the cell has the class 'no' (or simple just else), then we add the
 * privelaged role to the user.
 *
 * The changes are queued immediately, but are triggered in a separate, hidden
 * iframe to prevent page refresh from form submission. The downside of this is
 * that we have to update the CSS to the proper settings so that the user view 
 * is up-to-date.
 * 
 * Click events could have instead been handled by if 'yes' or 'no' were clicked
 * and then divining what role was selected. But that path would require a 
 * re-binding of the cell as it would not have the proper onClick event associated
 * with it. The method used is a bit more verbose than that option but it
 * does not require any rebindings after the event is over.
 */
function set_aam_bindings( )
{
    $( ".employee_is_admin,.employee_is_approver,.employee_is_manager" ).bind( 'click', function( )
    {
        var emp_num = $( this ).parent( ).attr( "id" );
        var add_rem = $( this ).hasClass( "yes" ) ? "remove" : "add";
        var type    = $( this ).hasClass( "employee_is_admin" ) ? "administrators" : $( this ).hasClass( "employee_is_approver" ) ? "approvers" : "invoiceManagers";

        gen_form( add_rem, type, emp_num );

        $( "#temp_form" ).submit( );
        $( "#temp_form" ).attr( "id", "old_form" );

        if( $( this ).hasClass( "yes" ) )
        {
            $( this ).removeClass( "yes" );
            $( this ).addClass( "no" );
        }
        else
        {
            $( this ).removeClass( "no" );
            $( this ).addClass( "yes" );
        }
    } );
}

//------------------------------------------------------------------------------------------

function other_bindings( )
{
    $( ".more" ).bind( 'click', function( )
    {
        var emp = $( this ).parent( ).attr( "id" );
        $( "#" + emp + "_more" ).toggle( );

        if( $( this ).html( ) == "more" )
            $( this ).html( "less" );
        else
            $( this ).html( "more" );
    } );
}

//------------------------------------------------------------------------------------------

$( document ).ready( function( )
{
    $( "#container" ).children( "div:first" ).addClass( "row_first" );
    $( "#container" ).children( "div:last" ).addClass( "row_last" );

    set_checks( );
    set_aam_bindings( );
    other_bindings( );
} );
