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
	            	${ allergy.allergen }
	            </li>
            <% } %>
        </ul>
		<% } %>
    </div>
</div>