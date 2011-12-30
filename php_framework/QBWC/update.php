<?php

require_once 'QuickBooks.php';
//require_once 'php/Log.php';

$Queue = new QuickBooks_Queue( 'mysql://root:diggy@localhost/sarariman' );
$Queue->enqueue( QUICKBOOKS_ADD_TIMETRACKING, 3 );

//lwrite( "updated..." );
?>
