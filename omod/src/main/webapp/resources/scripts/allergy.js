var app = angular.module("allergyApp", ['ui.bootstrap']);
	
app.controller("allergyController", [ '$scope', function($scope) {

    $scope.allergen = null;
    $scope.allergenType = null;
    $scope.severity = null;

    $scope.$watch('allergenType', function(newValue, oldValue) {
        // clear allergen any time they change the type
        $scope.allergen = null;
    });

    $scope.$watch('allergen', function(newValue, oldValue) {
        // if you had already specified allergen, then change it, clear other fields
        if (oldValue) {
            $('input.allergy-reaction').attr('checked', false);
            $('input.allergy-severity').attr('checked', false);
            $('#allergy-comment').val('');
        }
    });

    /*
     * This code lets us uncheck radio buttons.
     *
     * When an element is clicked, the model has not yet
     * been updated, so we check the value of the model 
     * to the value of the clicked element.  If they are 
     * identical, then the user is clicking the "current"
     * (selected) option and we can toggle it by setting 
     * the model to null.
     */
    $scope.toggle = function(event) {
        var keyboardEvent = event.type == 'keydown'
        var spaceOrEnterKey = keyboardEvent &&
                            (event.which == 13 ||
                             event.which == 32)
        var elem = event.target
        var modelKey = angular.element(elem).attr('ng-model')
        if (elem.value == $scope[modelKey]
           && (!keyboardEvent || spaceOrEnterKey)) {
            $scope[modelKey] = null
        } else {
            if (spaceOrEnterKey)
                $scope[modelKey] = elem.value
        }
        if (spaceOrEnterKey)
            event.preventDefault()
    }

}]);