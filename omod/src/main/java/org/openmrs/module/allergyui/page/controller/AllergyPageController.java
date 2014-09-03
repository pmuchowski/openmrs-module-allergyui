package org.openmrs.module.allergyui.page.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.openmrs.Concept;
import org.openmrs.Patient;
import org.openmrs.api.ConceptService;
import org.openmrs.module.allergyapi.Allergen;
import org.openmrs.module.allergyapi.AllergenType;
import org.openmrs.module.allergyapi.Allergies;
import org.openmrs.module.allergyapi.Allergy;
import org.openmrs.module.allergyapi.AllergyReaction;
import org.openmrs.module.allergyapi.api.PatientService;
import org.openmrs.module.uicommons.util.InfoErrorMessageUtil;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

public class AllergyPageController {
	
	public static final String DRUG_ALLERGENS_UUID = "162552AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
	
	public static final String FOOD_ALLERGENS_UUID = "162553AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
	
	public static final String ENVIRONMENT_ALLERGENS_UUID = "162554AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
	
	public static final String ALLERGY_REACTIONS_UUID = "162555AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
	
	public static final String ALLERGY_SEVERITIES_UUID = "159411AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
	
	public void controller(PageModel model, @RequestParam("patientId") Patient patient, UiUtils ui,
	                       @SpringBean("allergyService") PatientService patientService,
	                       @SpringBean("conceptService") ConceptService conceptService) {
		
		model.addAttribute("patient", patient);
		model.addAttribute("allergenTypes", AllergenType.values());
		
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
		
		//severities
		concepts = new ArrayList<Concept>();
		concept = conceptService.getConceptByUuid(ALLERGY_SEVERITIES_UUID);
		if (concept != null) {
			concepts = concept.getSetMembers();
		}
		model.addAttribute("severities", concepts);
	}
	
	public String post(@RequestParam("patientId") Patient patient, @RequestParam("allergen") Concept allergen,
	                   @RequestParam(value = "severity", required = false) Concept severity,
	                   @RequestParam(value = "comment", required = false) String comment,
	                   @RequestParam("allergyType") AllergenType allergenType,
	                   @RequestParam("reaction") List<Concept> reactionConcepts,
	                   @SpringBean("conceptService") ConceptService conceptService,
	                   @SpringBean("allergyService") PatientService patientService, HttpServletRequest request,
	                   PageModel model, HttpSession session, UiUtils ui) {
		
		Allergen algn = new Allergen(allergenType, allergen, null);
		Allergy allergy = new Allergy(patient, algn, severity, comment, null);
		List<AllergyReaction> reactions = getAllergyReactions(reactionConcepts, allergy);
		allergy.setReactions(reactions);
		
		Allergies allergies = patientService.getAllergies(patient);
		allergies.add(allergy);
		patientService.setAllergies(patient, allergies);
		
		InfoErrorMessageUtil.flashInfoMessage(session, "allergyui.addNewAllergy.success");
		
		return "redirect:allergyui/allergies.page?patientId=" + patient.getPatientId();
	}
	
	private List<AllergyReaction> getAllergyReactions(List<Concept> reactionConcepts, Allergy allergy) {
		List<AllergyReaction> reactions = new ArrayList<AllergyReaction>();
		for (Concept concept : reactionConcepts) {
			reactions.add(new AllergyReaction(allergy, concept, null));
		}
		return reactions;
	}
}
