<script type="text/javascript" src="http://yui.yahooapis.com/3.3.0/build/yui/yui-min.js" charset="utf-8" >
            
            //Create a new YUI instance with the required modules
            YUI( ).use( 'datatable', function( Y )
            { 
                var columns = [ "name", "title", "phone", "email" ];
                var rows = [ { name:"Test Name", title:"Test Title", phone:"555-5555", email:"test@test" } ];
                
                var table = new Y.DataTable.Base( 
                {
                    columnset: columns,
                    recordset: rows
                } ).render( "#testDataTable" );
                
            } );
            
</script>
