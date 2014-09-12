/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */
package org.openmrs.module.allergyui.page.controller;

import org.openmrs.Concept;
import org.openmrs.Patient;
import org.openmrs.module.allergyapi.Allergen;
import org.openmrs.module.allergyapi.AllergenType;
import org.openmrs.module.allergyapi.Allergies;
import org.openmrs.module.allergyapi.Allergy;
import org.openmrs.module.allergyapi.AllergyProperties;
import org.openmrs.module.allergyapi.AllergyReaction;
import org.openmrs.module.allergyapi.api.PatientService;
import org.openmrs.module.uicommons.UiCommonsConstants;
import org.openmrs.module.uicommons.util.InfoErrorMessageUtil;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.BindParams;
import org.openmrs.ui.framework.annotation.MethodParam;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

public class AllergyPageController {
	
	public void controller(PageModel model, @RequestParam(value = "allergyId", required = false) Integer allergyId,
	                       @RequestParam("patientId") Patient patient, UiUtils ui,
	                       @SpringBean("allergyService") PatientService patientService,
	                       @SpringBean("allergyProperties") AllergyProperties properties) {
		
		Allergy allergy;
		if (allergyId == null) {
			allergy = new Allergy(patient, null, null, null, null);
		} else {
			allergy = patientService.getAllergies(patient).getAllergy(allergyId);
		}
		
		setModelAttributes(allergy, model, properties);
	}
	
	public String post(@MethodParam("getAllergy") @BindParams Allergy allergy, @RequestParam("patientId") Patient patient,
	                   PageModel model, @SpringBean("allergyService") PatientService patientService,
	                   @SpringBean("allergyProperties") AllergyProperties properties, HttpSession session, UiUtils ui) {
		
		Allergies allergies = patientService.getAllergies(patient);
		String successMsgCode = "allergyui.message.success";
		if (allergy.getAllergyId() == null) {
			allergies.add(allergy);
			successMsgCode = "allergyui.addNewAllergy.success";
		}
		
		try {
			patientService.setAllergies(patient, allergies);
			InfoErrorMessageUtil.flashInfoMessage(session, successMsgCode);
			
			return "redirect:allergyui/allergies.page?patientId=" + patient.getPatientId();
		}
		catch (Exception e) {
			session.setAttribute(UiCommonsConstants.SESSION_ATTRIBUTE_ERROR_MESSAGE, "allergyui.message.fail");
		}
		
		setModelAttributes(allergy, model, properties);
		
		return null;
	}
	
	public Allergy getAllergy(@RequestParam(value = "allergyId", required = false) Integer allergyId,
	                          @RequestParam("patientId") Patient patient,
	                          @BindParams Allergen allergen,
	                          @RequestParam(value = "allergyReactionConcepts", required = false) List<Concept> allergyReactionConcepts,
                              @RequestParam(value = "severity", required = false) Concept severity,
                              @RequestParam(value = "reactionNonCoded", required = false) String reactionNonCoded,
                              @SpringBean("allergyProperties") AllergyProperties properties,
	                          @SpringBean("allergyService") PatientService patientService) {
		
		Allergy allergy;
		if (allergyId == null) {
			allergy = new Allergy(patient, allergen, null, null, null);
		} else {
			allergy = patientService.getAllergies(patient).getAllergy(allergyId);
		}
		
		List<Concept> existingReactionConcepts = getAllergyReactionConcepts(allergy);
		for (Concept concept : existingReactionConcepts) {
			//This reaction has been removed
			if (!allergyReactionConcepts.contains(concept)) {
				allergy.removeReaction(getAllergyReactionByConcept(allergy, concept));
			}
		}
		
		//Add any newly added ones
		for (Concept concept : allergyReactionConcepts) {
			String nonCodedReaction = concept.equals(properties.getOtherNonCodedConcept()) ? reactionNonCoded : null;
			allergy.addReaction(new AllergyReaction(null, concept, nonCodedReaction));
		}

        // need to explicitly handle severity because @BindParams doesn't handle the case where you unset it (and don't submit a parameter)
        allergy.setSeverity(severity);

		return allergy;
	}
	
	private void setModelAttributes(Allergy allergy, PageModel model, AllergyProperties properties) {
		
		model.addAttribute("allergy", allergy);
		model.addAttribute("allergenTypes", AllergenType.values());
		
		//drug allergens
		List<Concept> concepts = new ArrayList<Concept>();
		Concept concept = properties.getDrugAllergensConcept();
		if (concept != null) {
			concepts = concept.getSetMembers();
		}
		model.addAttribute("drugAllergens", concepts);
		
		//food allergens
		concepts = new ArrayList<Concept>();
		concept = properties.getFoodAllergensConcept();
		if (concept != null) {
			concepts = concept.getSetMembers();
		}
		model.addAttribute("foodAllergens", concepts);
		
		//environmental allergens
		concepts = new ArrayList<Concept>();
		concept = properties.getEnvironmentAllergensConcept();
		if (concept != null) {
			concepts = concept.getSetMembers();
		}
		model.addAttribute("environmentalAllergens", concepts);
		
		//allergy reactions
		concepts = new ArrayList<Concept>();
		concept = properties.getAllergyReactionsConcept();
		if (concept != null) {
			concepts = concept.getSetMembers();
		}
		model.addAttribute("reactionConcepts", concepts);
		
		//severities
		concepts = new ArrayList<Concept>();
		concept = properties.getMildSeverityConcept();
		if (concept != null) {
			concepts.add(concept);
		}
		concept = properties.getModerateSeverityConcept();
		if (concept != null) {
			concepts.add(concept);
		}
		concept = properties.getSevereSeverityConcept();
		if (concept != null) {
			concepts.add(concept);
		}
		model.addAttribute("severities", concepts);
		
		model.addAttribute("allergyReactionConcepts", getAllergyReactionConcepts(allergy));
	}
	
	private AllergyReaction getAllergyReactionByConcept(Allergy allergy, Concept concept) {
		for (AllergyReaction ar : allergy.getReactions()) {
			if (ar.getReaction().equals(concept)) {
				return ar;
			}
		}
		return null;
	}
	
	/**
	 * This should be a utility method in allergyapi module
	 */
	private List<Concept> getAllergyReactionConcepts(Allergy allergy) {
		List<Concept> reactionConcepts = new ArrayList<Concept>(allergy.getReactions().size());
		for (AllergyReaction ar : allergy.getReactions()) {
			reactionConcepts.add(ar.getReaction());
		}
		return reactionConcepts;
	}
}
