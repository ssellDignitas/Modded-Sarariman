/**
 * @author ssell
 * 
 * Form using this servlet must have 'qb/config_writer' as the action call.
 * This is set in the web.xml
 */

package com.dignitastechnologies.sarariman.qb;

import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;

//------------------------------------------------------------------------------------------

public class ConfigWriter extends HttpServlet
{
    private String configName = "qbwc_comm_settings.conf";

    public ConfigWriter( )
    {
        
    }
    
    //--------------------------------------------------------------------------------------

    @Override
    public void init( ServletConfig config ) throws ServletException
    {
        super.init( config );
    }

    //--------------------------------------------------------------------------------------

    @Override
    public void doPost( HttpServletRequest request, HttpServletResponse response ) throws ServletException, IOException
    {
        String[ ] params = { ( String )request.getParameter( "startMonth" ), ( String )request.getParameter( "startDay" ),
                             ( String )request.getParameter( "startYear" ),  ( String )request.getParameter( "endMonth" ),
                             ( String )request.getParameter( "endDay" ),     ( String )request.getParameter( "endYear" ) };
        
        //--------------------------------------------
        
        boolean vOK = true;
        boolean pass = true;
        String message = "";
        
        for( int i = 0; i < 6; i++ )
        {
            if( i == 2 || i == 5 )
                pass = isValid( params[ i ], true );
            else
                pass = isValid( params[ i ], false );
            
            if( !pass )
            {
                vOK = false;
                message += "Error: Parameter " + i + ": <i>'" + params[ i ] + "'</i> is invalid!<br>";
            }
        }
        
        //--------------------------------------------
        
        if( vOK )
        {
            message += setDates( params[ 0 ], params[ 1 ], params[ 2 ], params[ 3 ], params[ 4 ], params[ 5 ] );
        }
        
        //--------------------------------------------
        
        HttpSession session = request.getSession( true );
        
        session.setAttribute( "message", message );
        RequestDispatcher dispatcher = request.getRequestDispatcher( "/qb_settings.jsp" );
        dispatcher.forward( request, response );
    }

    //--------------------------------------------------------------------------------------

    public String setDates( String startMonth, String startDay, String startYear,
                            String endMonth,   String endDay,   String endYear )
    {
        // Due to the simplicity and brevity of the file, no XML or other mark-up language is used.
        String status = "";
        
        try
        {
            File f = new File( configName );
            
            if( !f.exists( ) )
            {
                status += "Error: qbwc_comm_settings.conf does not exist!<br>Creating file now...<br>";
                
                if( f.createNewFile( ) )
                    status += "File created successfully!<br>";
                else
                    status += "Error: File creation failed!<br>";
            }
            
            BufferedWriter out = new BufferedWriter( new FileWriter( configName ) );
            
            out.write( startMonth ); out.newLine( );
            out.write( startDay ); out.newLine( );
            out.write( startYear ); out.newLine( );
            
            out.write( endMonth ); out.newLine( );
            out.write( endDay ); out.newLine( );
            out.write( endYear );
            
            out.close( );
        }
        catch( IOException e )
        {            
            ErrorTracker.get( ).push( e.getMessage( ), "ConfigWriter.setDates" );
            
            return status;
        }
        
        return status + "Successfully saved new configuration settings.";
    }

    //--------------------------------------------------------------------------------------
    /// !!! this needs to be moved to a separate ConfigReader class
    /**
     * Returns the start end dates for the invoice inside an int array.
     * 
     *     [0] = start day
     *     [1] = start month
     *     [2] = start year
     *     [3] = end day
     *     [4] = end month
     *     [5] = end year
     * 
     * @return integer array
     */
    public int[ ] getDates( )
    {
        int[ ] dates = { 1, 1, 2000, 1, 1, 2010 };
        
        try
        {            
            FileReader fReader;
            BufferedReader bReader;
        
            fReader = new FileReader( configName );
            bReader = new BufferedReader( fReader );
            
            //----------------------------------------
            
            int index = 0;
            
            while( index < 6 )
            {
                dates[ index ] = Integer.parseInt( bReader.readLine( ) );
                
                index++;
            }
            
            bReader.close( );
            
        }
        catch( IOException e )
        {
            ErrorTracker.get( ).push( e.getMessage( ), "ConfigWriter.getDates" );
        }
        
        return dates;
    }
    
    //--------------------------------------------------------------------------------------
    
    protected boolean isValid( String param, boolean isYear )
    {
        if( param.length( ) == 0 )
            return false;
        else if( isYear == false && param.length( ) > 2 )
            return false;
        else if( isYear == true && param.length( ) != 4 )
            return false;
        
        for( int i = 0; i < param.length( ); i++ )
        {            
            if( !Character.isDigit( param.charAt( i ) ) )
                return false;
        }

        return true;
    }
}