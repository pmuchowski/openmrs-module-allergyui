angular.module('allergyui.widget.select-drug-concept', [ 'drugConceptService', 'ui.bootstrap' ])
    .directive('selectDrugConcept', ['DrugConceptService', function(DrugService) {
        return {
            restrict: 'E',
            scope: {
                ngModel: '=',
                id: '@', // the id of the typeahead textbox
                name: '@', //the name of the typeahead textbox
                formfieldname: '@', //the form field name
                prompt: '@' //Place holder for typeahead textbox
            },
            controller: function($scope) {
                $scope.inputId = ($scope.id ? $scope.id : 'select-drug-concept-' + Math.floor(Math.random() * 10000)) + '-input';

                function isMatch(match, query){
                    var q = emr.stripAccents(query.toLowerCase()).trim();
                    var cName = match.word.toLowerCase().trim();
                    return cName.indexOf(q) > -1;
                }

                $scope.search = function(query) {
                    var promise = DrugService.getDrugConcepts({ q: query, v: 'full' });
                    return promise.then(function(matches) {
                        var foundMatch = false;
                        for(var i in matches){
                            if(isMatch(matches[i], query) == true){
                                foundMatch = true;
                                break;
                            }
                        }
                        if(!foundMatch){
                            matches.push({word: query });
                        }
                        return matches;
                    });
                }

                $scope.print = function (item) {
                    if(item){
                        if (item.conceptName) {
                            return item.conceptName.display;
                        }
                        else if (item.concept) {
                            return item.concept.display;
                        }
                        else {
                            return item.word;
                        }
                    }
                }
            },
            template: '<input type="text" id="{{ inputId }}" name="{{ name }}" placeholder="{{ prompt }}" ng-model="ngModel" ' +
                'typeahead="drugConcept as print(drugConcept) for drugConcept in search($viewValue)" ' +
                'typeahead-editable="false" autocomplete="off" /> '+
                '<input type="text" name="{{ formfieldname }}" ng-model="ngModel.concept.uuid" style="display: none" />'
        };
    }]);