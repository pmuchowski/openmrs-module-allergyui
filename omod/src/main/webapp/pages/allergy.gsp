<%
    ui.decorateWith("appui", "standardEmrPage")
    ui.includeJavascript("uicommons", "angular.js")
	ui.includeJavascript("allergyui", "allergy.js")
    def isEdit = allergy.id != null;
%>
<script type="text/javascript">
    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.format(patient.familyName) }, ${ ui.format(patient.givenName) }" , link: '${ui.pageLink("coreapps", "clinicianfacing/patient", [patientId: patient.id])}'},
        { label: "${ ui.message("allergyui.allergies") }", link: '${ui.pageLink("allergyui", "allergies", [patientId: patient.id])}'},
        { label: "${ ui.message("allergyui.newAllergy") }" }
    ];
</script>

${ ui.includeFragment("coreapps", "patientHeader", [ patient: patient ]) }

<h2>
	${ ui.message(isEdit ? "allergyui.editAllergy" : "allergyui.addNewAllergy") }
</h2>

<div ng-app="allergyApp" ng-controller="allergyController" data-ng-init="allergenType='${allergy.allergen == null ? "DRUG" : allergy.allergen.allergenType}'">
	<form method="post" id="allergy" action="${ ui.pageLink("allergyui", "allergy", [patientId: patient.id]) }">
        <% if(isEdit){ %>
        <input type="hidden" name="allergyId" value="${allergy.id}" />
        <div id="types" class="horizontal inputs">
            <label>${ ui.message("allergyui.category") }:</label> ${allergy.allergen.allergenType}
        </div>
        <div id="types" class="horizontal inputs">
            <label>${ ui.message("allergyui.allergen") }:</label> ${allergy.allergen}
        </div>
        <% } else{ %>
        <label>${ ui.message("allergyui.allergen") }:</label>
	    <div id="types" class="horizontal">
	        <% allergenTypes.eachWithIndex { category, index -> %>
	            <div><input type="button" class="allergenType" <% if (index > 0) { %>style="background:darkgray"<% } %> name="allergenType" value="${ category }" ng-model="allergenType" ng-click="toggleAllergens(\$event, '${ category }')"></div>
	        <% } %>
	    </div>
        <% } %>
	    <div class="horizontal tabs">
            <% if(!isEdit){ %>
	        <div id="allergens" class="tab">
	            <div ng-show="allergenType == 'DRUG'">
	                <% drugAllergens.each { allergen -> %>
	                    <div>
                            <input type="radio" name="codedAllergen" value="${allergen.id}" class="coded_allergens" ng-model="allergen" ng-click="toggle(\$event)" ng-keydown="toggle(\$event)"
                                ${(allergy.allergen != null && allergen == allergy.allergen.codedAllergen) ? "checked=checked" : ""}>${allergen.name}
                        </div>
	                <% } %>
	            </div>
	            <div ng-show="allergenType == 'FOOD'">
	                <% foodAllergens.each { allergen -> %>
	                    <div>
                            <input type="radio" name="codedAllergen" value="${allergen.id}" class="coded_allergens" ng-model="allergen" ng-model="allergen" ng-click="toggle(\$event)" ng-keydown="toggle(\$event)"
                                ${(allergy.allergen != null && allergen == allergy.allergen.codedAllergen) ? "checked=checked" : ""}>${allergen.name}
                        </div>
	                <% } %>
	            </div>
	            <div ng-show="allergenType == 'ENVIRONMENTAL'">
	                <% environmentalAllergens.each { allergen -> %>
	                    <div>
                            <input type="radio" name="codedAllergen" value="${allergen.id}" class="coded_allergens" ng-model="allergen" ng-model="allergen" ng-click="toggle(\$event)" ng-keydown="toggle(\$event)"
                                ${(allergy.allergen != null && allergen == allergy.allergen.codedAllergen) ? "checked=checked" : ""}>${allergen.name}
                        </div>
	                <% } %>
	            </div>
	        </div>
            <% } %>
	        <div id="reactions" class="tabs tab">
	            <label>${ ui.message("allergyui.reactionSelection") }:</label>
	            <% reactionConcepts.each { reaction -> %>
	                <div><input type="checkbox" name="allergyReactionConcepts" value="${reaction.id}" ${ allergyReactionConcepts.contains(reaction) ? "checked=checked" : "" }>${reaction.name}</div>
	            <% } %>
	        </div>
	    </div>
	    <div id="severities" class="horizontal inputs">
	        <label>${ ui.message("allergyui.severity") }:</label>
	        <% severities.each { severity -> %>
	            <div><input type="radio" name="severity" value="${severity.id}" ${ severity == allergy.severity ? "checked=checked" : "" } ng-model="severity" ng-click="toggle(\$event)" ng-keydown="toggle(\$event)">${severity.name}</div>
	        <% } %>
	    </div>
	    <div id="comment" class="horizontal inputs" style="display:flex">
	        <label>${ ui.message("allergyui.comment") }:</label>
	        <input type="text" maxlength="1024" style="width:100%" name="comment" value="${allergy.comment != null ? allergy.comment : ""}"/>
	    </div>
	    <div id="actions">
	        <input type="submit" id="addAllergyBtn" class="confirm right" value="${ ui.message("coreapps.save") }" <% if(!isEdit){ %> ng-disabled="!allergen" <% } %>/>
	        <input type="button" class="cancel" value="${ ui.message("coreapps.cancel") }"
	         onclick="location.href='${ ui.pageLink("allergyui", "allergies", [patientId: patient.id]) }'" />
	    </div>
	</form>
</div>

<style>
	#allergy label {
		font-weight: bold;
	}
	
	.horizontal {
		display: table;
	}
	
	.horizontal > * {
		display: table-cell;
	}
	
	.tabs {
		width: 100%;
	}
	
	.tabs > div {
		width: 50%;
	}
	
	#reactions > div {
		float: left;
	}
	
	#reactions > div:nth-child(even) {
		clear: both;
	}
	
	form, #allergens, #reactions {
		border-collapse: collapse;
		padding-left: 20px;
		padding-right: 20px;
	}
	
	.tab {
		padding-top: 0px !important;
	}
	
	.tab > label {
		padding-bottom: 15px;
	}
	
	form > div {
		margin-bottom: 15px;
	}
	
	.inputs > div, .inputs > label {
		padding-right: 20px;
	}
</style>