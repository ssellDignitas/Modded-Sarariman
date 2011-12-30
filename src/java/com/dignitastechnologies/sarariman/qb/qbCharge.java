package com.dignitastechnologies.sarariman.qb;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class qbCharge
{
    public Pair< Integer, String > employee = new Pair< Integer, String >( );
    public Pair< Integer, String > charge   = new Pair< Integer, String >( );;
    public Pair< Integer, String > project  = new Pair< Integer, String >( );;
    public Pair< Integer, String > customer = new Pair< Integer, String >( );;
    
    public String date;
    
    public String duration;
    
    //--------------------------------------------------------------------------------------
    
    public qbCharge( )
    {
    }
    
    /**
     * Fills out the charge when provided with the specified data.
     * 
     * @param chargeNumber
     * @param employeeNumber
     * @param date 
     */
    public boolean populate( Connection sql, int chargeNumber, int employeeNumber, String dateStr )
    {
        PreparedStatement statement;
        ResultSet results;
        float dur;
        
        date = dateStr;
        charge.first = chargeNumber;
        employee.first = employeeNumber;
        
        try
        {            
            statement = sql.prepareStatement( "SELECT * FROM tasks WHERE id=" + charge.first + ";" );
            results = statement.executeQuery( );
            
            if( !results.next( ) )
                return false;
            
            // Name of the charge
            charge.second = results.getNString( results.findColumn( "name" ) );
            
            // Project number
            project.first = results.getInt( results.findColumn( "project" ) );
            
            //----------------------------------------
            // Project name and Customer ID
            
            statement = sql.prepareStatement( "SELECT * FROM projects WHERE id=" + project.first + ";" );
            results = statement.executeQuery( );
            
            if( !results.next( ) )
                return false;
            
            project.second = results.getNString( results.findColumn( "name" ) );
            customer.first = results.getInt( results.findColumn( "customer" ) );
            
            //----------------------------------------
            // Customer name
            
            statement = sql.prepareStatement( "SELECT * FROM customers WHERE id=" + customer.first + ";" );
            results = statement.executeQuery( );
            
            if( !results.next( ) )
                return false;
            
            customer.second = results.getNString( results.findColumn( "name" ) );     
            
            //----------------------------------------
            // Duration
            
            statement = sql.prepareStatement( "SELECT duration FROM hours WHERE date='" + date + "' AND employee=" + employee.first + " AND task=" + charge.first + ";" );
            results = statement.executeQuery( );
            
            if( !results.next( ) )
                return false;
            
            dur = results.getFloat( results.findColumn( "duration" ) );
        }
        catch( SQLException e )
        {
            ErrorTracker.get( ).push( e.getMessage( ), "qbCharge.populate" );
            
            return false;
        } 
        
        // Format Date
        dur *= 60;
        
        int hour = dur < 60 ? 0 : ( int )dur / 60;
        int mins = dur < 60 ? ( int )dur : ( int )dur % 60;
        
        duration = "PT" + hour + "H" + mins + "M0S";
        
        return true;
    }
} 