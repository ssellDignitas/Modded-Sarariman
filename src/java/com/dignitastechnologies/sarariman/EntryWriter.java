package com.dignitastechnologies.sarariman;

import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.sql.*;

import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import com.dignitastechnologies.sarariman.qb.DatabaseConnector;

public class EntryWriter 
    extends HttpServlet
{
    private Connection sqlConnection;

    public EntryWriter( )
    {
        sqlConnection = DatabaseConnector.get( ).getConnection( );
    }

    @Override
    public void init( ServletConfig config ) 
        throws ServletException
    {
        super.init( config );
    }

    /**
     * @author ssell
     *    
     * Processes the servlet request, and passes off the parameters to the appropriate handler.  
     */
    @Override
    public void doPost( HttpServletRequest request, HttpServletResponse response ) 
        throws ServletException, IOException
    {
        String modifyOrNew = ( String )request.getParameter( "requestType" );
System.out.println( "\n> Entry Writer triggered" );
        if( modifyOrNew.equals( "new_entry" ) )
        {
            makeNewEntry( ( String )request.getParameter( "date" ),
                          ( String )request.getParameter( "week" ),
                          ( String )request.getParameter( "billable_task" ),
                          ( String )request.getParameter( "duration" ),
                          ( String )request.getParameter( "description" ),
                          ( String )request.getParameter( "employee" ) );
        }
        else
        {
            makeModifyEntry( ( String )request.getParameter( "date" ),
                             ( String )request.getParameter( "task" ),
                             ( String )request.getParameter( "duration" ),
                             ( String )request.getParameter( "description" ),
                             ( String )request.getParameter( "reason" ),
                             ( String )request.getParameter( "employee" ),
                             ( String )request.getParameter( "remote_user" ),
                             ( String )request.getParameter( "remote_address" ) );
        }
    }

    public void makeNewEntry( String date, String week, String task, String duration, String description, String employee )
    {
        //INSERT INTO hours (employee, task, date, description, duration) values(?, ?, ?, ?, ?)
        System.out.println( "> makeModifyEntry triggered..." );
        System.out.print( "\tDate: " + date + "\n\tTask: " + task + "\n\tDura: " + duration + "\n\tDesc: " + description + "\n\tEmpl: " + employee + "\n" );
        try
        {
            Statement statement = sqlConnection.createStatement( );
            statement.executeUpdate( "INSERT INTO hours VALUES(" + employee + ", " + task + ", '" + date + "', '" + description + "', " + duration + ", 0 )" );
        }
        catch( SQLException e )
        {
            System.out.println( "! error in make modifyEntry (" + e.getErrorCode( ) + ")\n\t" + e.getMessage( ) );
        }
        
        System.out.println( "> makeModifyEntry complete" );
    }

    public void makeModifyEntry( String date, String task, String duration, String description, String reason, String employee, String user, String address )
    {
        //UPDATE hours SET duration=?,description=? WHERE date=? AND employee=? and task=?
        //INSERT INTO hours_changelog (employee, task, date, reason, remote_address, remote_user, duration) values(?, ?, ?, ?, ?, ?, ?)
        System.out.println( "> makeModifyEntry triggered..." );
        System.out.print( "\tDate: " + date + "\n\tTask: " + task + "\n\tDura: " + duration + "\n\tDesc: " + description + "\n\tReas: " + reason + "\n\tEmpl: " + employee + "\n\tUser: " + user + "\n\tAddr: " + address + "\n" );
             
        DateFormat dateFormat = new SimpleDateFormat( "yyyy-MM-dd HH:mm:ss" );
        Date time = new Date( );
        
        try
        {
            Statement statement = sqlConnection.createStatement( );
            statement.executeUpdate( "UPDATE hours SET duration=" + duration + ", description='" + description + "' WHERE date='" + date + "' AND employee=" + employee + " AND task=" + task );
            statement.executeUpdate( "INSERT INTO hours_changelog VALUES(" + employee + ", " + task + ", '" + date + "', '" + dateFormat.format( time ) + "', " + duration + ", '" + address + "', '" + user + "', '" + reason + "')" );
        }
        catch( SQLException e )
        {
            System.out.println( "! error in make modifyEntry (" + e.getErrorCode( ) + ")\n\t" + e.getMessage( ) );
        }
        
        System.out.println( "> makeModifyEntry complete" );
    }
}
