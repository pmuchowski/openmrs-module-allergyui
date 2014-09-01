package org.openmrs.module.allergyui.page.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.openmrs.Concept;
import org.openmrs.Patient;
import org.openmrs.activelist.AllergySeverity;
import org.openmrs.api.ConceptService;
import org.openmrs.module.allergyapi.Allergen;
import org.openmrs.module.allergyapi.AllergenType;
import org.openmrs.module.allergyapi.Allergies;
import org.openmrs.module.allergyapi.Allergy;
import org.openmrs.module.allergyapi.AllergyReaction;
import org.openmrs.module.allergyapi.api.PatientService;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.action.SuccessResult;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

public class AllergyPageController {
	
	public static final String DRUG_ALLERGENS_UUID = "162552AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
	
	public static final String FOOD_ALLERGENS_UUID = "162553AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
	
	public static final String ENVIRONMENT_ALLERGENS_UUID = "162554AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
	
	public static final String ALLERGY_REACTIONS_UUID = "162555AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
	
	public static final String MODERATE_UUID = "1499AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
	
	public static final String MILD_UUID = "1498AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
	
	public static final String SEVERE_UUID = "1500AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
	
	public void controller(PageModel model, @RequestParam("patientId") Patient patient, UiUtils ui,
	                       @SpringBean("allergyService") PatientService patientService,
	                       @SpringBean("conceptService") ConceptService conceptService) {
		
		model.addAttribute("patient", patient);
		
		//drug allergens
		List<Concept> concepts = new ArrayList<Concept>();
		Concept concept = conceptService.getConceptByUuid(DRUG_ALLERGENS_UUID);
		if (concept != null) {
			concepts = concept.getSetMembers();
		}
		model.addAttribute("drugAllergens", concepts);
		
		//food allergens
		concepts = new ArrayList<Concept>();
		concept = conceptService.getConceptByUuid(FOOD_ALLERGENS_UUID);
		if (concept != null) {
			concepts = concept.getSetMembers();
		}
		model.addAttribute("foodAllergens", concepts);
		
		//environmental allergens
		concepts = new ArrayList<Concept>();
		concept = conceptService.getConceptByUuid(ENVIRONMENT_ALLERGENS_UUID);
		if (concept != null) {
			concepts = concept.getSetMembers();
		}
		model.addAttribute("environmentalAllergens", concepts);
		
		//allergy reactions
		concepts = new ArrayList<Concept>();
		concept = conceptService.getConceptByUuid(ALLERGY_REACTIONS_UUID);
		if (concept != null) {
			concepts = concept.getSetMembers();
		}
		model.addAttribute("allergyReactions", concepts);
	}
	
	public String post(@RequestParam("patientId") Patient patient, @RequestParam("allergen") Concept allergen,
	                   @RequestParam("severity") AllergySeverity severity, @RequestParam("comment") String comment,
	                   @RequestParam("allergyType") AllergenType allergenType,
	                   @RequestParam("reaction") List<Concept> reactionConcepts,
	                   @SpringBean("conceptService") ConceptService conceptService,
	                   @SpringBean("allergyService") PatientService patientService, HttpServletRequest request,
	                   PageModel model, UiUtils ui) {
		
		Allergen algn = new Allergen(allergenType, allergen, null);
		Concept severityConcept = getSeverityConcept(severity, conceptService);
		Allergy allergy = new Allergy(patient, algn, severityConcept, comment, null);
		List<AllergyReaction> reactions = getAllergyReactions(reactionConcepts, allergy);
		allergy.setReactions(reactions);
		
		Allergies allergies = patientService.getAllergies(patient);
		allergies.add(allergy);
		patientService.setAllergies(patient, allergies);
		
		return new SuccessResult(ui.message("allergyui.addNewAllergy.success")).toString();
	}
	
	private Concept getSeverityConcept(AllergySeverity severity, ConceptService conceptService) {
		if (severity == AllergySeverity.MILD) {
			return conceptService.getConceptByUuid(MILD_UUID);
		} else if (severity == AllergySeverity.MODERATE) {
			return conceptService.getConceptByUuid(MODERATE_UUID);
		} else {
			return conceptService.getConceptByUuid(SEVERE_UUID);
		}
	}
	
	private List<AllergyReaction> getAllergyReactions(List<Concept> reactionConcepts, Allergy allergy) {
		List<AllergyReaction> reactions = new ArrayList<AllergyReaction>();
		for (Concept concept : reactionConcepts) {
			reactions.add(new AllergyReaction(allergy, concept, null));
		}
		return reactions;
	}
}
