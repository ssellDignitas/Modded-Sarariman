<%-- 
    Document   : currentForm
    Created on : Jul 13, 2011, 3:26:20 PM
    Author     : root
--%>

<style type="text/css">
    .submit_button
    {
        background-color: #FFFFFF;
        background-image: url( "images/accept.png" );
        background-repeat: no-repeat;
        background-position: left center;
        
        padding-left:17px;
        
        border: 1px solid #E1E1E1;
        
        min-width: 30px;
        min-height: 20px;
    }
</style>

<form action="${request.requestURI}" method="post">

    <!-- LHS of Form -->
    <div style="position:relative; float:left; width:25%;">
        
        <!-- Specific Day Date Display -->
        <fmt:formatDate var="now" value="${du:now()}" type="date" pattern="yyyy-MM-dd" />
        
        <div style="position:relative; float:left; width:50%;">
            
            <!-- Charge Number Drop-Down -->
            <label for="billabe_task">Charge Number:</label>
            <select name="billable_task" id="billable_task" onchange="resetSelect('unbillable_task');enable('submit');">

                <option selected="true"></option>

                <c:forEach var="task" items="${sarariman:billableTasks(sarariman,user)}">

                    <option value="${task.id}">${fn:escapeXml(task.name)} (${task.id})

                        <c:if test="${!empty task.project}">

                            ${fn:escapeXml(task.project.name)}:${fn:escapeXml(sarariman.customers[task.project.customer].name)}

                        </c:if>

                    </option>

                </c:forEach>

            </select>   
        </div>
                            
        <div style="position:relative; float:right; width:45%;">
        
            <!-- Not including unbillable task-->
            <!-- Duration Field-->

            <label for="duration">Duration:</label>
            <input size="5" type="text" name="duration" id="duration" />
        
        </div>
    </div>
                        
    <!-- RHS of Form -->
     
    <div class="stripe_back" style="position:relative; float:right; width:72%;border-left:1px solid #E1E1E1;padding-left:15px;">
    
        <label for="description">Description:</label>

        <br />

        <textarea cols="120" rows="10" name="description" id="description"></textarea>

        <fmt:formatDate var="weekString" value="${week}" type="date" pattern="yyyy-MM-dd" />

        <input type="hidden" name="week" value="${weekString}" />
        <br />

        <div style="position:relative; float:right;">
            
            <br />
            <input type="submit" name="recordTime" value="Record" id="submit" class="submit_button" disabled="true"/>
        </div>
     </div>

</form>
