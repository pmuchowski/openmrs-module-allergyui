<div class="info-section allergies">
    <div class="info-header" onclick="location.href='${ui.pageLink("allergyui", "allergies", [patientId: patient.patient.id])}';" style="cursor: pointer;">
        <i class="icon-medical"></i>
        <h3>${ ui.message("allergyui.allergies").toUpperCase() }</h3>
    </div>
    <div class="info-body">
        <% if (allergies.allergyStatus != "See list") { %>
			 ${ ui.message(allergies.allergyStatus) }
		<% } else { %>
        <ul>
            <% allergies.each { allergy -> %>
	            <li>
	            	${ allergy.allergen } =>
	            	<% allergy.reactions.eachWithIndex { reaction, index -> %><% if (index > 0) { %>,<% } %> ${reaction}<% } %>
	            	<% if (allergy.severity) { %> (${ allergy.severity.name }) <% } %>
	            </li>
            <% } %>
        </ul>
		<% } %>
    </div>
</div>