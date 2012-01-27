/*
 * Copyright (C) 2009 StackFrame, LLC
 * This code is licensed under GPLv2.
 */
package com.stackframe.sarariman;

import java.io.IOException;
import java.util.concurrent.TimeUnit;

import java.util.logging.Logger;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import java.util.*;

import com.dignitastechnologies.sarariman.qb.Base64;

/**
 * A simple filter for overriding REMOTE_USER.
 *
 * @author mcculley
 */
public class RemoteUser implements Filter {

    private final Logger logger = Logger.getLogger(getClass().getName());
    private Directory directory;

    public void init(FilterConfig filterConfig) throws ServletException {
        Sarariman sarariman = (Sarariman)filterConfig.getServletContext().getAttribute("sarariman");
        directory = sarariman.getDirectory();
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        if (request instanceof HttpServletRequest) {
            HttpServletRequest httpServletRequest = (HttpServletRequest)request;
            
            //------------------------------------------------------------------------------
            
            Enumeration headers = httpServletRequest.getHeaderNames( );
            String header;
            String baseString = null;
            String username = null;
            
            while( headers.hasMoreElements( ) )
            {
                header = ( String )headers.nextElement( );
                
                if( header.equals( "authorization" ) )
                    baseString = httpServletRequest.getHeader( header ).substring( 6 );
            }    
            
            if( baseString != null )
            {
                Base64 decoder = new Base64( );

                byte[ ] decoded = decoder.decode( baseString.toCharArray( ) );
                
                for( int iter = 0; decoded[ iter ] != 58; iter++ )
                {
                    if( username == null )
                        username = "" + ( char )decoded[ iter ];
                    else
                        username += ( char )decoded[ iter ];
                }
            }
            
            //------------------------------------------------------------------------------
            
            //String username = httpServletRequest.getRemoteUser();
            if (username == null) {
                username = System.getProperty("user.name");
                logger.info("No REMOTE_USER.  Using " + username);
                System.out.println("No REMOTE_USER.  Using " + username);
            }

            Employee user = directory.getByUserName().get(username);
                logger.info("setting user to " + user);
                System.out.println("setting user to " + user);
            request.setAttribute("user", user);
        }

        long start = System.nanoTime();
        chain.doFilter(request, response);
        long stop = System.nanoTime();
        long took = stop - start;
        System.err.println("request="+((HttpServletRequest)request).getRequestURL() +" took=" + TimeUnit.NANOSECONDS.toMillis(took));
    }

    public void destroy() {
    }

}
