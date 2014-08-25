<%
    ui.decorateWith("appui", "standardEmrPage")
%>
<script type="text/javascript">
    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.format(patient.familyName) }, ${ ui.format(patient.givenName) }" , link: '${ui.pageLink("coreapps", "clinicianfacing/patient", [patientId: patient.id])}'},
        { label: "${ ui.message("allergyui.allergies") }" }
    ];
    
    var patient = { id: ${ patient.id } };
</script>

${ ui.includeFragment("coreapps", "patientHeader", [ patient: patient ]) }

<h2>
	${ ui.message("allergyui.allergies") }
</h2>

<table id="allergies" width="100%" border="1" cellspacing="0" cellpadding="2">
    <thead>
	    <tr>
	        <th>${ ui.message("allergyui.allergen") }</th>
	        <th>${ ui.message("allergyui.reaction") }</th>
	        <th>${ ui.message("allergyui.severity") }</th>
	        <th>${ ui.message("allergyui.comment") }</th>
	        <th>${ ui.message("allergyui.lastUpdated") }</th>
	        <th>${ ui.message("coreapps.actions") }</th>
	    </tr>
    </thead>
    
    <tbody>
    	<% if (allergies.size() == 0) { %>
            <tr>
                <td colspan="5" align="center"> ${ allergies.allergyStatus } </td>
            </tr>
        <% } %>
        
        <% allergies.each { allergy -> %>
            <tr>
                <td> ${ allergy.allergen } </td>
                <td> 
                	<% allergy.reactions.eachWithIndex { reaction, index -> %>
	               		<% if (index > 0) { %>,<% } %> ${reaction}	
	                <% } %>
                </td>
                <td> ${ allergy.severity.name } </td>
                <td> ${ allergy.comment } </td>
                <td> ${ ui.formatDatetimePretty(allergy.dateLastUpdated) } </td>
                <td>
                	<i class="icon-pencil edit-action" title="${ ui.message("coreapps.edit") }"></i>
                	<i class="icon-remove delete-action" title="${ ui.message("coreapps.delete") }"></i>
                </td>
            </tr>
        <% } %>
    </tbody>
</table>

<br/>

<button class="confirm">
    ${ ui.message("allergyui.addNewAllergy") }
</button>

<button class="confirm" style="float:right">
    ${ ui.message("allergyui.noKnownAllergy") }
</button>