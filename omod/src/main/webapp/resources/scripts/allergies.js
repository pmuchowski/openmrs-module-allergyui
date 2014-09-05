var confirmNoKnownAllergyDialog = null;
var removeAllergyDialog = null;

$(document).ready( function() {

    confirmNoKnownAllergyDialog = emr.setupConfirmationDialog({
        selector: '#allergyui-confirm-no-known-allergy-dialog',
        actions: {
            cancel: function() {
                confirmNoKnownAllergyDialog.close();
            }
        }
    });
    
    removeAllergyDialog = emr.setupConfirmationDialog({
        selector: '#allergyui-remove-allergy-dialog',
        actions: {
            cancel: function() {
            	removeAllergyDialog.close();
            }
        }
    });

});

function showConfirmNoKnownAllergyDialog() {
    confirmNoKnownAllergyDialog.show();
}

function showRemoveAllergyDialog() {
    removeAllergyDialog.show();
}