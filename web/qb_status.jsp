<%-- 
    Document   : QB_Test
    Created on : Sep 6, 2011, 1:30:02 PM
    Author     : root
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.dignitastechnologies.sarariman.qb.ErrorTracker"%>
<%@ page import="com.dignitastechnologies.sarariman.qb.DatabaseConnector"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>QB Status</title>
        
        <!-- Styles -->
        <link type="text/css" rel="stylesheet" href="styles/general.css" />
        
        <style type="text/css">            
            .button
            {
                background-color: #FFFFFF;
                
                color: #333;

                padding:16px;

                border: 1px solid #E1E1E1;

                min-width: 100px;
                min-height: 30px;
                
                font:1.5em Tahoma,Geneva,sans-serif;
            }
        </style>
        
        <!-- Scripts -->
        <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"></script>
        <script type="text/javascript" src="scripts/main_nav.js"></script> 
        
        <script type="text/javascript">
            $( document ).ready( function( )
            {
                $( '#clearButton' ).bind( 'click', function( ){ window.location.reload( ); } );
            } );
        </script>
        
    </head>
    
    <body>
              
        <div id="header">
            <!-- Main Navigation Pane -->
            <%@include file="UC_header.jsp" %>
        </div>
        
        <!-- /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ -->

        <div class="wrapper">
            
            <div class="message">
                <h1><br><br>QuickBooks System Status</h1><br>
                <h2>
                    View the error log as well as QBWC/database connection status.
                </h2></div>
            <br><br><br><br>
            
            <!-- /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ -->
            
            <div style="width:90%;margin:auto;">
                <h1>Connections</h1><br>
                
                <div style="width:98%; margin:auto;">
                    
                    <%                        
                        if( DatabaseConnector.get( ).testConnection( ) )
                            out.print( "<h2><img src='images/icons/active/action_check.png'> Sarariman Database</h2><div style='margin-left:10px;background-color:#DDEEDD;color:#DDEEDD;'>connected</div>" );
                        else
                            out.print( "<h2><img src='images/icons/active/action_delete.png'> Sarariman Database</h2><div style='margin-left:10px;background-color:#EEDDDD;color:#EEDDDD;'>not connected</div>" );
                    %>
                    
                    <br>
                    <!-- /\/\/\/\/\ -->
                    <br>
                    
                    <h2><img src='images/icons/active/action_delete.png'> QuickBooks Web Connector</h2>
                    <div style='margin-left:10px;background-color:#EEDDDD;color:#EEDDDD;'>not connected</div>
                    
                </div>
            </div>
            
            
            <!-- /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ -->
            
            <br><br><br><br>
            
            <div style="width:90%;margin:auto;">
                <h1>Error Log</h1><br>
                <h2>Errors are displayed in order of most recent to oldest logged.</h2>
                <br><br>
                
                <div class="drop-shadow curved curved-hz-2" style="width:98%; margin:auto;font:1.3em 'Courier New', Courier, monospace;">
                    
                    
                    <%
                        String[ ] messages = ErrorTracker.get( ).getAll( );
                        int count = ErrorTracker.get( ).count( );
                        
                        if( count == 0 )
                            out.print( "<div id='errorLog' style='margin-left:10px;padding:5px;border-left:20px solid #DDEEDD;'>" + messages[ 0 ] + "</div>" );
                        else
                            for( int i = 0; i < count; i++ )
                                out.print( "<div id='errorLog' style='margin-left:10px;margin-bottom:2px;padding:5px;border-left:20px solid #EEDDDD;'>" + messages[ i ] + "</div>" );
                    %>
                    </div>
                    
                </div>    
                <!-- Not working properly - onClick -->
                <br><br><br><br><br>
                <button class="button" id="clearButton" style="float:right;" onClick="<% ErrorTracker.get( ).clear( ); %>" >Clear Log</button>
            </div>
        
        </div> <!-- end wrapper -->
        
        <!-- /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ -->
        
        <div class="footer_stick">
            
            <div class="footer">
                <%@include file="UC_footer.jsp" %>
            </div>
            
        </div>

    </body>
</html> 
