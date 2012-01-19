<style type="text/css">
    .header_button
    {
        margin-left:20px;
        margin-right:20px;
        padding:3px;
        font-weight:bold;
        color:#FFFFFF;
        cursor:hand;
    }

    .header_button:hover
    {
        color:#B2C986;
    }

    .logout_button
    {
        float:right;
        width:25%;
        padding:8px;
        padding-right:30px;
        margin-right:25px;
        
        cursor:pointer;
        color: #FFFFFF;

        background-image: url('images/icons/disabled/logout.png');
        background-position: right center;
        background-repeat: no-repeat;
    }

    .logout_button:hover
    {
        color:#DD0000;
        cursor:pointer;
        background-image: url('images/icons/active/logout_hover.png');
    }

    .shadow
    {
        box-shadow:         0 2px 6px 2px rgba( 50, 50, 50, 0.3 );
        -moz-box-shadow:    0 2px 6px 2px rgba( 50, 50, 50, 0.3 );
        -webkit-box-shadow: 0 2px 6px 2px rgba( 50, 50, 50, 0.3 );
    }
</style>

<div style="margin:0;padding:0;top:0;background-color:#272132;border-bottom:1px solid #000000;min-height:30px;font-size:14px;font-family: Arial, sans-serif;" class="shadow">
    <div class="logout_button"> 
        <span style="float:right;font-weight:bold;">${user.fullName}</span> 
    </div>

    <div style="float:left;margin-right:30%;padding:8px;">
        <a href="index.jsp"><span class="header_button">Home</span></a>
        <a href="timecard.jsp"><span class="header_button">TimeSheet</span></a>
        <a href="tools.jsp"><span class="header_button">Tools</span></a>
        <a href="help.jsp"><span class="header_button">Help</span></a>
    </div>
</div>
