package org.openmrs.module.allergyui.page.controller;

import org.openmrs.Patient;
import org.openmrs.module.allergyapi.api.PatientService;
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
}
