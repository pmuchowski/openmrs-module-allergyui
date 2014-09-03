<%
    ui.decorateWith("appui", "standardEmrPage")
    ui.includeJavascript("uicommons", "angular.js")
	ui.includeJavascript("allergyui", "allergy.js")
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
	${ ui.message("allergyui.addNewAllergy") }
</h2>

<div ng-app="allergyApp" ng-controller="allergyController">
	<form method="post" id="allergy" action="${ ui.pageLink("allergyui", "allergy", [patientId: patient.id]) }">
	    <div id="types" class="horizontal inputs">
	        <label>${ ui.message("allergyui.categories") }:</label>
	        <% allergenTypes.eachWithIndex { category, idx -> %>
	            <div><input type="radio" name="allergyType" ng-model="allergyType" value="${ category }" ${ if(idx == 0) "checked=checked" }>${ category }</div>
	        <% } %>
	    </div>
	    <div class="horizontal tabs">
	        <div id="allergens" class="tab">
	            <label>${ ui.message("allergyui.allergen") }:</label>
	            <div ng-show="allergyType == 'DRUG'">
	                <% drugAllergens.each { allergen -> %>
	                    <div><input type="radio" name="allergen" value="${allergen.id}">${allergen.name}</div>
	                <% } %>
	            </div>
	            <div ng-show="allergyType == 'FOOD'">
	                <% foodAllergens.each { allergen -> %>
	                    <div><input type="radio" name="allergen" value="${allergen.id}">${allergen.name}</div>
	                <% } %>
	            </div>
	            <div ng-show="allergyType == 'ENVIRONMENTAL'">
	                <% environmentalAllergens.each { allergen -> %>
	                    <div><input type="radio" name="allergen" value="${allergen.id}">${allergen.name}</div>
	                <% } %>
	            </div>
	        </div>
	        <div id="reactions" class="tabs tab">
	            <label>${ ui.message("allergyui.reactionSelection") }:</label>
	            <% allergyReactions.each { reaction -> %>
	                <div><input type="checkbox" name="reaction" value="${reaction.id}">${reaction.name}</div>
	            <% } %>
	        </div>
	    </div>
	    <div id="severities" class="horizontal inputs">
	        <label>${ ui.message("allergyui.severity") }:</label>
	        <% severities.each { severity -> %>
	            <div><input type="radio" name="severity" value="${severity.id}">${severity.name}</div>
	        <% } %>
	    </div>
	    <div id="comment" class="horizontal inputs">
	        <label>${ ui.message("allergyui.comment") }:</label>
	        <input type="text" name="comment"/>
	    </div>
	    <div id="actions">
	        <input type="submit" id="addAllergyBtn" class="confirm right" value="${ ui.message("coreapps.save") }" />
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
		border: 1px solid #DDD;
		border-collapse: collapse;
		padding: 20px;
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