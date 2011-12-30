package com.dignitastechnologies.sarariman.qb;

import javax.naming.InitialContext;
import java.sql.*;
import javax.sql.*;

public class DatabaseConnector
{
    private static DatabaseConnector instance;
    private final String dbName = "java:comp/env/jdbc/sarariman";
    private Connection permConnection = null;
    
    private DatabaseConnector( )
    {
        DataSource source;
        
        try
        {
             source = ( DataSource ) new InitialContext( ).lookup( dbName );
             
             try 
            {
               permConnection = source.getConnection( );
            } 
            catch ( SQLException e ) 
            {
                ErrorTracker.get( ).push( e.getMessage( ), "DatabaseConnector.Constructor" );
            }
        }
        catch( Exception e )
        {
            ErrorTracker.get( ).push( e.getMessage( ), "DatabaseConnector.Constructor" );
        }
    }
    
    public static DatabaseConnector get( )
    {
        if( instance == null )
            instance = new DatabaseConnector( );
        
        return instance;
    }
    
    
    
    public boolean testConnection( )
    {
        Connection connection;
        
        DataSource source;
        
        try
        {
             source = ( DataSource ) new InitialContext( ).lookup( dbName );
        }
        catch( Exception e )
        {
            ErrorTracker.get( ).push( e.getMessage( ), "DatabaseConnector.testConnection" );
            return false;
        }
        
        try 
        {
           connection = source.getConnection( );
        } 
        catch ( SQLException e ) 
        {
            ErrorTracker.get( ).push( e.getMessage( ), "DatabaseConnector.testConnection" );
            return false;
        }
        
        try{ connection.close( ); }
        catch( SQLException e ){ }        
        
        return true;
    }
    
    public Connection getConnection( )
    {
        return permConnection;
    }
}