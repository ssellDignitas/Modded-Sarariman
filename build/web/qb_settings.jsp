<%-- 
    Document   : QB_Test
    Created on : Sep 6, 2011, 1:30:02 PM
    Author     : root
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.dignitastechnologies.sarariman.qb.ConfigWriter"%>
<%@ page import="com.dignitastechnologies.sarariman.qb.qbXMLWriter"%>
<%@taglib prefix="sarariman" uri="/WEB-INF/tlds/sarariman" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>QB Settings</title>
        
        <!-- Styles -->
        <link type="text/css" rel="stylesheet" href="styles/general.css" />
        
        <style type="text/css">
            .date_box
            {
                font:2.5em Tahoma,Geneva,sans-serif;
                text-align:center;
                
                padding:0;
                margin:0;
                
                width:50px;
                height:50px;
                
                border:1px solid #EFEFEF;
            }
            
            .button
            {
                background-color: #FFFFFF;

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
    $( 'input' ).each( function( )
    {
        var number = 2;

        if( $( this ).attr( 'id' ).indexOf( 'Year' ) > 0 )
        {
            number = 4;
        }
        
        $( this ).keyup( function( )
        {
            var length = $( this ).attr( 'value' ).length;
            
            if( length >= number )
            {
                if( length > number )
                {
                    $( this ).attr( 'value', $( this ).attr( 'value' ).substring( 0, number ) );
                }
                
                //--------------------------------------------------------
               
                var id = $( this ).attr( 'id' );
                
                // I do not like what is coming up and need to change it...
                if( id.indexOf( 'start' ) >= 0 )
                {
                    if( id.indexOf( 'Month' ) >= 0 )
                        $( '#startDay' ).focus( );
                    else if( id.indexOf( 'Day' ) >= 0 )
                        $( '#startYear' ).focus( );
                    else
                        $( '#endMonth' ).focus( );
                }
                else
                {
                    if( id.indexOf( 'Month' ) >= 0 )
                        $( '#endDay' ).focus( );
                    else if( id.indexOf( 'Day' ) >= 0 )
                        $( '#endYear' ).focus( );
                    else
                        $( this ).blur( );
                }
            }
        } );  
    } );
    
    $( '#submitButton' ).bind( 'click', function( )
        {
            var w = window.open( "http://" + document.location.hostname + "/QBWC/update.php" );
            
            setTimeout( function( )
            {
                w.close( );
                window.location.reload( )
            }, 1000 );
         } );
} );
</script>
        
    </head>
    
    <body>
        
        <%
                ConfigWriter writer = new ConfigWriter( );
                int[ ] array = new int[ 6 ];
                
                array = writer.getDates( );
                
                int sD = 0; int sM = 0; int sY = 0;
                int eD = 0; int eM = 0; int eY = 0;
                
                if( array != null )
                {
                    sD = array[ 0 ];
                    sM = array[ 1 ];
                    sY = array[ 2 ];
                    eD = array[ 3 ];
                    eM = array[ 4 ];
                    eY = array[ 5 ];
                }
            %>
        
        <div id="header">
            <!-- Main Navigation Pane -->
            <%@include file="UC_header.jsp" %>
        </div>
        
        <!-- /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ -->

        <div class="wrapper">
            
            <div class="message">
                <h1><br><br>QuickBooks Invoice Export Settings</h1><br>
                <h2>
                    Modify the desired settings and click the 'save' button to update the <b>qbwc_comm_settings.conf</b> file.<br>
                    This file is used while communicating with the <i>QuickBooks Web Connector</i> to determine what data to provide.
                </h2></div>
            <br><br><br><br>
            
            <form method="post" action="qb/config_writer" target="thei" >
                
            <div id="holder">
                
                <div style="position:relative;width:45%;float:left;text-align:center;overflow:auto;">
                    <p class="big">Start Date (MM-DD-YYYY)</p>
                    
                    <div class="drop-shadow curved curved-hz-2" style="width:90%;margin-top:0px;">
                        <input type="text" name="startMonth" id="startMonth" class="date_box" value="<%=sD%>"/>
                        
                        <span style="font-size:4em;color:#CCC;margin:15px;">-</span>
                        
                        <input type="text" name="startDay" id="startDay" class="date_box" value="<%=sM%>"/>
                        
                        <span style="font-size:4em;color:#CCC;margin:15px;">-</span>
                        
                        <input type="text" name="startYear" id="startYear" style="width:100px;" class="date_box" value="<%=sY%>"/>
                    </div>
                    
                </div> <!-- end left date pick -->

                <div style="position:relative;width:45%;float:right;text-align:center;">
                    <p class="big">End Date (MM-DD-YYYY)</p>
                    
                    <div class="drop-shadow curved curved-hz-2" style="width:90%;margin-top:0px;">
                        <input type="text" name="endMonth" id="endMonth" class="date_box" value="<%=eD%>"/>
                        
                        
                        <span style="font-size:4em;color:#CCC;margin:15px;">-</span>
                        
                        <input type="text" name="endDay" id="endDay" class="date_box" value="<%=eM%>"/>
                        
                        <span style="font-size:4em;color:#CCC;margin:15px;">-</span>
                        
                        <input type="text" name="endYear" id="endYear" style="width:100px;" class="date_box" value="<%=eY%>"/>
                    </div>
                </div> <!-- end right date pick -->
                
                <br><br>
                
            </div> <!-- end holder -->
            
            <div style="width:94%;text-align:right;">
                <input type="submit" id="submitButton" class="button" value="Save" />
            </div>
            </form>
            
            <iframe style="display:none;" name="thei" id="thei"></iframe>
            
            <br><br>
            
            <c:if test="${message != null}">
                <div id="retMessage" style="width:90%;margin:auto !important;">
                    <h2 style="font-family:'Courier New', Courier, monospace;">
                        ${message}
                    </h2>
                </div>
                    
                <c:set var="message" value="${null}"/>
            </c:if>
            
            <br>
            <%
                qbXMLWriter xml = new qbXMLWriter( );

                out.print( xml.createXML( ) );
            %>
            
        
        </div> <!-- end wrapper -->
        
        <!-- /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ -->
        
        <div class="footer_stick">
            
            <div class="footer">
                <%@include file="UC_footer.jsp" %>
            </div>
            
        </div>

    </body>
</html> 
