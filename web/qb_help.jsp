<%@page contentType="text/html" pageEncoding="UTF-8"
        import="java.util.LinkedHashSet,com.stackframe.sarariman.Directory,com.stackframe.sarariman.Employee,
        com.stackframe.sarariman.Sarariman" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Authorized? -->
<c:if test="${!user.administrator}">
    <script type="text/javascript">
        window.location.replace( "unauthorized.jsp" );
    </script>
</c:if>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>

    <!-- Scripts -->
    <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"></script>
    <script type="text/javascript" src="scripts/utilities.js"></script>

    <!-- Styles  -->
    <link type="text/css" rel="stylesheet" href="styles/general.css" />

</head>
<body>

    <!------------------- NAVI ------------------->
    <div id="header">
        <%@include file="UC_header.jsp" %>
    </div>

    <!------------------- BODY ------------------->
    <div class="wrapper">

        <div class="message">
            <h1><br><br>
                QBWC Help
            </h1>
        </div><br>

        <div id="holder">
            <div class="drop-shadow">
                <h2><b>Getting Started</b></h2>
                <br/>
                
                The QuickBooks Web Connector (QBWC) is an application that allows for communication between the Sarariman web-service
                and your local QuickBooks installation.<br>
                To begin transferring data from the Sarariman databases to QuickBooks you must first follow the steps detailed below.
                
                <br/><br/><br/>
                
                <h2><b>QWC File</b></h2>
                <br/>
                
                <div style="background-color:#EEEEEE;"><b>Download it: <a href="/sng/resources/Sarariman.qwc">Sarariman.qwc</a></b></div>
                <br/>
                
                The <i>.qwc</i> file is what lets the QBWC know who it needs to talk to in order to begin the data transfer process.
                When it is on your system you simply need to double-click it and the QBWC will begin and it will also remember where
                the file is kept for future convenience. Please note that before the web connector can launch, you must first have an
                instance of QuickBooks running with the proper company file loaded.
                
                <br/><br/><br/>
                
                <h2><b>Security Certificate</b></h2>
                <br/>
                
                <div style="background-color:#EEEEEE;"><b>Download it: <a href="/sng/resources/Sarariman.crt">Sarariman.crt</a></b></div>
                <br/>
                
                A security certificate exists to verify that a server is who it says it is. Typically, these are assigned and provided
                by internationally recognized companies such as VeriSign. Due to the internal nature of Sarariman there currently exists
                no need to request a certificate for our local servers, and so instead one was generated for in-house use. The certificate
                is required by the QBWC or else it will refuse to open a connection to the Sarariman server.<br/><br/>
                
                The only catch is that since the certificate is not generated/signed by one of the companies that are automatically
                accepted by your web browser, you must install it yourself. To install the certificate please follow the following 
                directions:<br/><br/>
                
                <ol>
                    <li>Download <i>Sarariman.crt</i> from the link above</li>
                    <li>Run Internet Explorer (it does not matter if you normally use Firefox or Chrome, run Internet Explorer)</li>
                    <li>Navigate to <i>Tools -> Content -> Certificates -> Trusted Root Certification Authorities</i></li>
                    <li>Click <i>Import...</i> and follow the wizard that pops up</li>
                    <li>When prompted for the <i>File Name:</i> simply browse to and select the downloaded certificate</li>
                    <li>You should be done. The certificate will appear in the list like below:</li>
                </ol>
                
                <br/><br/><center><img src="images/help/security_certificate.png"></center><br/><br/>
                    
                <br/><br/>
                
                <h2><b>Importing Data to QuickBooks</b></h2>
                <br/>
                
                Prior to transferring any data from the Sarariman databases to your local QuickBooks installation you must first use
                the <b><a href="/sng/qb_settings.jsp">Export Settings</a></b> tool. This tool not only specifies the date range from
                which to pull timesheet records but it also ensures that the data transmitted is up-to-date.<br/><br/>
                
                After using the <i>Export Settings</i> tool the Sarariman systems are ready to transfer timesheets. On your computer
                you must now launch the QuickBooks Web Connector. To do so, it can either be opened from within QuickBooks or you
                can simply double-click the <i>.qwc</i> file that you downloaded above. Next, you need to ensure that the proper Company
                File is loaded into the active instance of QuickBooks. Finally make sure that the <i>Password</i> field next to the 
                Sarariman process inside the QBWC is filled in with the correct password. All that is left to do is check the box
                next to <i>Sarariman</i> and then click the <i>Update Selected</i> button.<br/><br/>
                
                
                
                
            </div>
        </div>

        <div class="push"></div>

    </div>

    <!------------------- FOOT ------------------->
    <div class="footer_stick">
        <div class="footer">
            <%@include file="UC_footer.jsp" %>
        </div>
    </div>

</body>
</html>