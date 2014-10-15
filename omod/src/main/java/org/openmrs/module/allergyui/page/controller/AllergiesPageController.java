package org.openmrs.module.allergyui.page.controller;

import java.util.Collections;
import java.util.Comparator;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.openmrs.Patient;
import org.openmrs.module.allergyapi.Allergies;
import org.openmrs.module.allergyapi.AllergyConstants;
import org.openmrs.module.allergyapi.api.PatientService;
import org.openmrs.module.allergyui.extension.html.AllergyComparator;
import org.openmrs.module.uicommons.UiCommonsConstants;
import org.openmrs.module.uicommons.util.InfoErrorMessageUtil;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.ui.util.ByFormattedObjectComparator;
import org.springframework.web.bind.annotation.RequestParam;

public class AllergiesPageController {
	
	public void controller(PageModel model, @RequestParam("patientId") Patient patient, UiUtils ui,
	                       @SpringBean("allergyService") PatientService patientService) {
		
		Allergies allergies = patientService.getAllergies(patient);
		Comparator comparator = new AllergyComparator(new ByFormattedObjectComparator(ui));
		Collections.sort(allergies, comparator);
		
		model.addAttribute("patient", patient);
		model.addAttribute("allergies", allergies);
		model.addAttribute("privilegeModifyAllergies", AllergyConstants.PRIVILEGE_MODIFY_ALLERGIES);
	}
	
	public String post(@RequestParam("patientId") Patient patient,
	                   @RequestParam(value = "action", required = false) String action, 
	                   @RequestParam(value = "allergyId", required = false) Integer allergyId,
	                   PageModel model,
	                   HttpSession session, @SpringBean("allergyService") PatientService patientService) {
		
		if (StringUtils.isNotBlank(action)) {
			try {
				Allergies allergies = null;
				if ("confirmNoKnownAllergies".equals(action)) {
					allergies = new Allergies();
					allergies.confirmNoKnownAllergies();
				}
				else if ("deactivate".equals(action)) {
					allergies = new Allergies();
				}
				else if ("removeAllergy".equals(action)) {
					allergies = patientService.getAllergies(patient);
					allergies.remove(allergies.getAllergy(allergyId));
				}
				
				patientService.setAllergies(patient, allergies);
				
				InfoErrorMessageUtil.flashInfoMessage(session, "allergyui.message.success");
				
				return "redirect:allergyui/allergies.page?patientId=" + patient.getPatientId();
			}
			catch (Exception e) {
				session.setAttribute(UiCommonsConstants.SESSION_ATTRIBUTE_ERROR_MESSAGE, "allergyui.message.fail");
			}
		}
		
		model.addAttribute("allergies", patientService.getAllergies(patient));
		
		return null;
	}
}
