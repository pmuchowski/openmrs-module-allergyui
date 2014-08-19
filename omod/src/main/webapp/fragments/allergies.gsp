<div class="info-section allergies">
    <div class="info-header" onclick="location.href='${ui.pageLink("allergyui", "allergies", [patientId: patient.patient.id])}';" style="cursor: pointer;">
        <i class="icon-medical"></i>
        <h3>${ ui.message("allergyui.allergies").toUpperCase() }</h3>
    </div>
    <div class="info-body">

        <div id="allergies-container" class="in collapse">
            ${ ui.message(allergies.allergyStatus == "See list" ? "uicommons.loading.placeholder" :  allergies.allergyStatus) }
        </div>
    </div>
</div>