var app = angular.module("allergyApp", []);
	
app.controller("allergyController", [ '$scope', function($scope) {

    $scope.toggleAllergens = function(event, category){
    	$scope.allergen = null;
        $scope.allergenType = category;
        $('.allergenType').css('background', 'darkgray');
        event.target.style.background = '';
    }
    
    /*
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