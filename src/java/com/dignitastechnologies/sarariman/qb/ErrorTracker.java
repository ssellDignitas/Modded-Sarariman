package com.dignitastechnologies.sarariman.qb;

import java.util.*;

/**
 * @author ssell
 * 
 * Simple error tracker that can be used by the web-service for debugging purposes.
 */
public class ErrorTracker
{
    private static ErrorTracker instance;
    private ArrayList errors = new ArrayList( );
    
    //--------------------------------------------------------------------------------------
    
    private ErrorTracker( ){ }
    
    public static ErrorTracker get( )
    {
        if( instance == null )
            instance = new ErrorTracker( );
        
        return instance;
    }
    
    //--------------------------------------------------------------------------------------
    
    /**
     * @author ssell
     * 
     * Returns number of errors currently logged.
     */
    public int count( )
    {
        return errors.size( );
    }
    
    //--------------------------------------------------------------------------------------
    
    /**
     * @author ssell
     * 
     * Adds a new error to the list.
     * 
     * @param raw The error message
     * @param calledBy What class/function caused the error
     */
    public void push( String raw, String calledBy )
    {
        errors.add( calledBy + " : " + raw + "<br>" );
    }
    
    //--------------------------------------------------------------------------------------
    
    /**
     * @author ssell
     * 
     * Returns the most recent error and removes it from the list.
     * Returns 'No errors logged' if the list is empty.
     */
    public String pop( )
    {
        if( errors.isEmpty( ) )
            return "No errors logged.<br>";
        
        String message = ( String )errors.get( errors.size( ) - 1 );
        
        errors.remove( errors.size( ) - 1 );
        
        return message;
    }
    
    //--------------------------------------------------------------------------------------
    
    /**
     * @author ssell
     * 
     * Returns the most recent error.
     */
    public String getLast( )
    {
        if( errors.isEmpty( ) )
            return "No errors logged.<br>";
        else
            return ( String )errors.get( errors.size( ) - 1 );
    }
    
    //--------------------------------------------------------------------------------------
    
    /**
     * @author ssell
     * 
     * Returns all currently logged errors from most recent to oldest
     */
    public String[ ] getAll( )
    {
        String[ ] array;
        
        if( errors.isEmpty( ) )
        {
            array = new String[ 1 ];
            array[ 0 ] = "No errors logged.<br>";
            return array;
        }
        else
        {
            array = new String[ errors.size( ) ];
            
            for( int i = errors.size( ) - 1; i >= 0; i-- )
            {
                array[ i ] = ( String )errors.get( i );
            }
            
            return array;
        }
    }
    
    //--------------------------------------------------------------------------------------
    
    /**
     * @author ssell
     * 
     * Clears the list of logged errors.
     */
    public void clear( )
    {
        errors.clear( );
    }
            
}