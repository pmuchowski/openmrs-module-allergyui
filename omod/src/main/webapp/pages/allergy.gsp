<%
    ui.decorateWith("appui", "standardEmrPage")
    ui.includeJavascript("uicommons", "angular.min.js")
    ui.includeJavascript("uicommons", "angular-ui/ui-bootstrap-tpls-0.11.0.min.js")
	ui.includeJavascript("allergyui", "allergy.js")

    ui.includeCss("allergyui", "allergy.css")
    def isEdit = allergy.id != null;
    def title = isEdit ?
            ui.message("allergyui.editAllergy", ui.format(allergy.allergen)) :
            ui.message("allergyui.addNewAllergy");

    def allergensByType = [
        DRUG: drugAllergens,
        FOOD: foodAllergens,
        ENVIRONMENTAL: environmentalAllergens
    ]
%>
<script type="text/javascript">
    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.format(patient.familyName) }, ${ ui.format(patient.givenName) }" , link: '${ui.pageLink("coreapps", "clinicianfacing/patient", [patientId: patient.id])}'},
        { label: "${ ui.message("allergyui.allergies") }", link: '${ui.pageLink("allergyui", "allergies", [patientId: patient.id])}'},
        { label: "${ ui.escapeJs(title) }" }
    ];
</script>

${ ui.includeFragment("coreapps", "patientHeader", [ patient: patient ]) }

<h2>${ title }</h2>

<div ng-app="allergyApp" ng-controller="allergyController" ng-init="severity = ${ allergy?.severity?.id }; allergenType='${allergy.allergen == null ? "DRUG" : allergy.allergen.allergenType}'">
	<form method="post" id="allergy" action="${ ui.pageLink("allergyui", "allergy", [patientId: patient.id]) }">

        <input type="hidden" name="allergenType" value="{{allergenType}}"/>
        <% if (isEdit) { %>
            <input type="hidden" name="allergyId" value="${allergy.id}" />
        <% } %>

        <% if (!isEdit) { %>
            <div id="allergens">

                <div id="types" class="button-group horizontal">
                    <% allergenTypes.each { category -> %>
                    <label class="button small" ng-model="allergenType" btn-radio="'${ui.format(category)}'" ng-class="{ confirm: allergenType == '${ui.format(category)}' }">
                        ${ category }
                    </label>
                    <% } %>
                </div>

                <% allergensByType.each {
                    def typeName = it.key
                    def allergens = it.value
                %>
                    <ul ng-show="allergenType == '${ typeName }'">
                        <% allergens.each { allergen -> %>
                        <li>
                            <input id="allergen-${allergen.id}" type="radio" name="codedAllergen" value="${allergen.id}" class="coded_allergens" ng-model="allergen"
                                ${(allergy.allergen != null && allergen == allergy.allergen.codedAllergen) ? "checked=checked" : ""}/>
                            <label for="allergen-${allergen.id}">${ui.format(allergen)}</label>
                            
                            <% if (allergen.uuid == '5622AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA') { %>
                            	<input type="text" name="nonCodedAllergen" ng-show="allergen == '${allergen.id}'"/>
                            <% } %>
                        </li>
                        <% } %>
                    </ul>
                <% } %>
            </div>
        <% } %>

        <div id="reactions">
            <label class="heading">${ ui.message("allergyui.reactionSelection") }:</label>
            <ul>
            <% reactionConcepts.each { reaction -> %>
                <li>
                    <input <% if (!isEdit) { %> ng-model="reaction${reaction.id}" <% } %> type="checkbox" id="reaction-${reaction.id}" class="allergy-reaction" name="allergyReactionConcepts" value="${reaction.id}" ${ allergyReactionConcepts.contains(reaction) ? "checked=checked" : "" }/>
                    <label for="reaction-${reaction.id}">${ui.format(reaction)}</label>
                    <% if (reaction.uuid == '5622AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA') { %>
                    	<input type="text" name="reactionNonCoded" ng-show="reaction${reaction.id}"/>
                    <% } %>
                </li>
            <% } %>
            </ul>
        </div>

	    <div id="severities" class="horizontal">
	        <label class="heading">${ ui.message("allergyui.severity") }:</label>
	        <% severities.each { severity -> %>
	            <p>
                    <input type="radio" id="severity-${severity.id}" class="allergy-severity" name="severity" value="${severity.id}" ${ severity == allergy.severity ? "checked=checked" : "" } ng-checked="severity == ${severity.id}" ng-model="severity" ng-click="toggle(\$event)" ng-keydown="toggle(\$event)"/>
                    <label for="severity-${severity.id}">${ui.format(severity)}</label>
                </p>
	        <% } %>
	    </div>

	    <div id="comment" style="display:flex">
	        <label>${ ui.message("allergyui.comment") }:</label>
	        <textarea id="allergy-comment" maxlength="1024" name="comment">${allergy.comment != null ? allergy.comment : ""}</textarea>
	    </div>

	    <div id="actions">
	        <input type="submit" id="addAllergyBtn" class="confirm right" value="${ ui.message("coreapps.save") }" <% if(!isEdit){ %> ng-disabled="!allergen" <% } %>/>
	        <input type="button" class="cancel" value="${ ui.message("coreapps.cancel") }"
	         onclick="location.href='${ ui.pageLink("allergyui", "allergies", [patientId: patient.id]) }'" />
	    </div>
	</form>
</div>
