var removeAllergyDialog = null;

$(document).ready( function() {
    
    removeAllergyDialog = emr.setupConfirmationDialog({
        selector: '#allergyui-remove-allergy-dialog',
        actions: {
            cancel: function() {
            	removeAllergyDialog.close();
            }
        }
    });

});

function showRemoveAllergyDialog() {
    removeAllergyDialog.show();
}