package com.dignitastechnologies.sarariman.qb;

import java.io.*;
import java.util.*;
import java.sql.*;

public class qbXMLWriter
{
    private Connection sqlConnection;
    
    /**
     * @author ssell
     * 
     * Establishes the connection with the SQL database
     */
    public qbXMLWriter( )
    {
        sqlConnection = DatabaseConnector.get( ).getConnection( );
    }
    
    /**
     * @author ssell
     * 
     * Writes the qbXML to a text file. The data used in creating the qbXML is drawn from the database
     * using the current date range found in the config file.
     */
    public String createXML( )
    {
        if( sqlConnection == null )
        {
            ErrorTracker.get( ).push( "NULL sqlConnection", "qbXMLWriter.createXML" );
            return "error";
        }
        
        //--------------------------------------------
        
        ArrayList< ResultSet > sqlResults = ( ArrayList )getIndividualSQLData( );
        ArrayList< qbCharge > charges = new ArrayList< qbCharge >( );
        
        //--------------------------------------------
        
        ResultSet result;
        qbCharge charge;
        
        boolean repeat = false;
        int cnt = 0;
        int rows = 0;
        
        for( int i = 0; i < sqlResults.size( ); i++ )
        {
            cnt = 0;
            
            result = sqlResults.get( i );
            
            try
            {
                result.last( );
                rows = result.getRow( );
                result.beforeFirst( );
            }
            catch( SQLException e )
            {
                ErrorTracker.get( ).push( e.getMessage( ), "qbXMLWriter.createXML" );
                continue;
            }
                    
            //----------------------------------------
            
            for( int iter = 0; iter < rows; iter++ )
            {              
                try
                {
                    if( result.next( ) )
                    {
                        charge = new qbCharge( );

                        if( charge.populate( sqlConnection,
                                             result.getInt( result.findColumn( "task" ) ),
                                             result.getInt( result.findColumn( "employee" ) ),
                                             result.getDate( result.findColumn( "date" ) ).toString( ) ) )
                        {                
                            charges.add( charge );
                        }
                    }
                }
                catch( SQLException e )
                {
                    ErrorTracker.get( ).push( e.getMessage( ), "qbXMLWriter.createXML" );
                    continue;
                }  
            }
        }
        
        //--------------------------------------------
        
        recordXML( charges );

        return "abc";
    }
    
    //--------------------------------------------------------------------------------------
    
    /**
     * @author ssell
     * 
     * Goes date by date through the pre-specified range, and retrieves the SQL data and then returns it as an ArrayList collection.
     * 
     * @return 
     */
    private Collection< ResultSet > getIndividualSQLData( )
    {
        Collection< ResultSet > results = new ArrayList< ResultSet >( );
        
        // MM-DD-YYYY
        int[ ] dates = new ConfigWriter( ).getDates( );
        
        //--------------------------------------------
        
        // Need to quickly know how many days are in each month
        int[ ] daysInMonth = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
        int[ ] currentDay = { dates[ 0 ], dates[ 1 ], dates[ 2 ] };
        
        //--------------------------------------------
        
        PreparedStatement statement;
        String dateStr = "";
        
        String tDay, tMonth;
        
        while( currentDay [ 0 ] != dates[ 3 ] || currentDay[ 1 ] != dates[ 4 ] || currentDay[ 2 ] != dates[ 5 ] )
        {
            //----------------------------------------
            
            // The dates in the database are stored as YYYY-MM-DD as opposed to MM-DD-YYYY so have to rearrange the values.
            // Also have to account for values < 10 that require an appending 0
            
            tDay = currentDay[ 1 ] < 10 ? "0" + currentDay[ 1 ] : "" + currentDay[ 1 ];
            tMonth = currentDay[ 0 ] < 10 ? "0" + currentDay[ 0 ] : "" + currentDay[ 0 ];
            
            dateStr = currentDay[ 2 ] + "-" + tMonth + "-" + tDay;
            
            try
            {
                statement = sqlConnection.prepareStatement( "SELECT * FROM hours WHERE date = '" + dateStr + "' ORDER BY task;" );
                
                results.add( statement.executeQuery( ) );
            }
            catch( SQLException e )
            {
                ErrorTracker.get( ).push( e.getMessage( ), "qbXMLWriter.getIndividualSQLData" );
            }
            
            //----------------------------------------
            
            // increment to the next day
            if( currentDay[ 1 ] != daysInMonth[ currentDay[ 0 ] - 1 ] )
                currentDay[ 1 ] += 1;
            else
            {
                // increment to next month
                currentDay[ 1 ] = 1;
                
                if( currentDay[ 0 ] != 12 )
                    currentDay[ 0 ] += 1;
                else
                {
                    // increment to next year
                    currentDay[ 0 ] = 1;
                    currentDay[ 2 ] += 1;
                }
            }
                
        }
        
        //Let out one prior to the end of the range...
        dateStr = "" + dates[ 5 ] + "-";
        dateStr += dates[ 3 ] < 10 ? "0" + dates[ 3 ] + "-" : "" + dates[ 3 ] + "-";
        dateStr += dates[ 4 ] < 10 ? "0" + dates[ 4 ] : "" + dates[ 4 ];
            
        try
        {
            statement = sqlConnection.prepareStatement( "SELECT * FROM hours WHERE date = '" + dateStr + "' ORDER BY task;" );

            results.add( statement.executeQuery( ) );
        }
        catch( SQLException e )
        {
            ErrorTracker.get( ).push( e.getMessage( ), "qbXMLWriter.getIndividualSQLData" );
        }
        
        return results;
    }
    
    //--------------------------------------------------------------------------------------
    
    private void recordXML( ArrayList< qbCharge > p_Charges )
    {
        String xmlStr = "<?xml version=\"1.0\" encoding=\"utf-8\"?><?qbxml version=\"2.0\"?><QBXML><QBXMLMsgsRq onError=\"stopOnError\">";
        qbCharge charge;
        
        for( int i = 0; i < p_Charges.size( ); i++ )
        {
            charge = p_Charges.get( i );
            
            //def macro is Date:Charge#:Employee#
            xmlStr += "<TimeTrackingAddRq><TimeTrackingAdd>" +
                      "<TxnDate>" + charge.date + "</TxnDate>" +
                      "<EntityRef><FullName>" + /*charge.employee.second*/"TestUser" + "</FullName></EntityRef>" +
                      "<CustomerRef><FullName>" + charge.customer.second + ":" + charge.project.second + "</FullName></CustomerRef>" +
                      "<ItemServiceRef><FullName>" + charge.charge.second + "</FullName></ItemServiceRef>" +
                      "<Duration>" + charge.duration + "</Duration>" +
                      "</TimeTrackingAdd></TimeTrackingAddRq>";
        }    
        
        xmlStr += "</QBXMLMsgsRq></QBXML>";
        
        //----------------------------------------------------------------------------------
        
        try
        {
            File f = new File( "/var/www/QB/sarariman_qb.txt" );
            
            if( !f.exists( ) )
            {
                f.createNewFile( );
            }
            
            BufferedWriter out = new BufferedWriter( new FileWriter( "/var/www/QBWC/res/sarariman_qb.txt" ) );
            
            out.write( xmlStr );
            
            out.close( );
        }
        catch( IOException e )
        {            
            ErrorTracker.get( ).push( e.getMessage( ), "qbXMLWriter.recordXML" );
        }
    }
}
