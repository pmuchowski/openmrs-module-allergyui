package org.openmrs.module.allergyui.page.controller;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.openmrs.Patient;
import org.openmrs.module.allergyapi.Allergies;
import org.openmrs.module.allergyapi.api.PatientService;
import org.openmrs.module.uicommons.UiCommonsConstants;
import org.openmrs.module.uicommons.util.InfoErrorMessageUtil;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

public class AllergiesPageController {
	
	public void controller(PageModel model, @RequestParam("patientId") Patient patient, UiUtils ui,
	                       @SpringBean("allergyService") PatientService patientService) {
		
		model.addAttribute("patient", patient);
		model.addAttribute("allergies", patientService.getAllergies(patient));
	}
	
	public String post(@RequestParam("patientId") Patient patient,
	                   @RequestParam(value = "action", required = false) String action, PageModel model,
	                   HttpSession session, @SpringBean("allergyService") PatientService patientService) {
		
		if (StringUtils.isNotBlank(action)) {
			try {
				Allergies allergies = new Allergies();
				if ("confirmNoKnownAllergies".equals(action)) {
					allergies.confirmNoKnownAllergies();
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
