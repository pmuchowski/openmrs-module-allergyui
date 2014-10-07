<div class="info-section allergies">
    <div class="info-header">
        <i class="icon-medical"></i>
        <h3>${ ui.message("allergyui.allergies").toUpperCase() }</h3>
        <i class="icon-pencil edit-action right" title="${ ui.message("coreapps.edit") }" onclick="location.href='${ui.pageLink("allergyui", "allergies", [patientId: patient.patient.id])}';"></i>
    </div>
    <div class="info-body">
        <% if (allergies.allergyStatus != "See list") { %>
			 ${ ui.message(allergies.allergyStatus) }
		<% } else { %>
        <ul>
            <% allergies.each { allergy -> %>
	            <li>
	            	<span style="color:#00463f">${ ui.format(allergy.allergen.coded ? allergy.allergen.codedAllergen : allergy.allergen) }</span>
	            	<span style="color:darkgray">&rArr;</span>
	            	<% allergy.reactions.eachWithIndex { reaction, index -> %>
	            		<span style="color:darkgray"><% if (index > 0) { %>,<% } %> ${ui.format(reaction.reactionNonCoded ? reaction : reaction.reaction)}</span>
	            	<% } %>
	            </li>
            <% } %>
        </ul>
		<% } %>
    </div>
</div>