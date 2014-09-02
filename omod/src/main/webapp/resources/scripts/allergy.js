var app = angular.module("allergyApp", []);
	
app.controller("allergyController", [ '$scope', function($scope) {
    $scope.allergyType = 'DRUG';
}]);