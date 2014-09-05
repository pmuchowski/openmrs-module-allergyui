var app = angular.module("allergyApp", []);
	
app.controller("allergyController", [ '$scope', function($scope) {

    $scope.toggleAllergens = function(){
        $('.coded_allergens').attr('checked', false);
    }

}]);