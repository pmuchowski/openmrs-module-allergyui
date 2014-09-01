<%
    ui.decorateWith("appui", "standardEmrPage")
%>
<script type="text/javascript">
    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.format(patient.familyName) }, ${ ui.format(patient.givenName) }" , link: '${ui.pageLink("coreapps", "clinicianfacing/patient", [patientId: patient.id])}'},
        { label: "${ ui.message("allergyui.allergies") }", link: '${ui.pageLink("allergyui", "allergies", [patientId: patient.id])}'},
        { label: "${ ui.message("allergyui.newAllergy") }" }
    ];
    
    var patient = { id: ${ patient.id } };
</script>

${ ui.includeFragment("coreapps", "patientHeader", [ patient: patient ]) }

<h2>
	${ ui.message("allergyui.addNewAllergy") }
</h2>

<style>
    table tr td {
        border: none;
        display: inline-block;
    }
    
    table:not(.unstyled) tr:nth-child(even) {
	  background: white;
	}
</style>

<div ng-app="allergyApp">
<form method="POST">
	<table id="allergy">
		<tr>
			<td>
				${ ui.message("allergyui.categories") }
			</td>
			<td>
				<input type="radio" name="allergyType" ng-model="allergyType" value="DRUG" checked="checked"> ${ ui.message("allergyui.drug") }
			</td>
			<td>
				<input type="radio" name="allergyType" ng-model="allergyType" value="FOOD"> ${ ui.message("allergyui.food") }
			</td>
			<td>
				<input type="radio" name="allergyType" ng-model="allergyType" value="ENVIRONMENT"> ${ ui.message("allergyui.environment") }
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<fieldset>
	                <legend>${ui.message("allergyui.allergen")}:</legend>
	                <% drugAllergens.each { allergen -> %>
	                	<input type="radio" name="allergen" value="${allergen.id}">${allergen.name}<br/>
	                <% } %>
	            </fieldset>
			</td>
			<td colspan="2">
				<fieldset>
	                <legend>${ui.message("allergyui.reactionSelection")}</legend>
	                <% allergyReactions.each { reaction -> %>
	                	<input type="checkbox" name="reaction" value="${reaction.id}">${reaction.name}<br/>
	                <% } %>
	            </fieldset>
			</td>
		</tr>
		<tr>
			<td>
				${ ui.message("allergyui.severity") }
			</td>
			<td>
				<input type="radio" name="severity" value="MILD"> ${ ui.message("allergyui.mild") }
			</td>
			<td>
				<input type="radio" name="severity" value="MODERATE"> ${ ui.message("allergyui.moderate") }
			</td>
			<td>
				<input type="radio" name="severity" value="SEVERE"> ${ ui.message("allergyui.severe") }
			</td>
		</tr>
		<tr>
			<td>
				${ ui.message("allergyui.comment") }
			</td>
			<td colspan="3" style="width:80%">
				<input type="text" name="comment">
			</td>
		</tr>
		<tr>
			<td colspan="3">
				<button class="cancel" onclick="location.href='${ ui.pageLink("allergyui", "allergies", [patientId: patient.id]) }'; return false;">
				    ${ ui.message("coreapps.cancel") }
				</button>
			</td>
			<td align="right" style="float:right">
				<button class="confirm" type="submit">
				    ${ ui.message("coreapps.save") }
				</button>
			</td>
		</tr>
	</table>
</form>
</div>