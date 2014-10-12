angular.module('drugConceptService', ['ngResource', 'uicommons.common'])

    .factory('DrugConcept', function($resource) {
        return $resource("/" + OPENMRS_CONTEXT_PATH  + "/ws/rest/v1/conceptsearch", null, {
            query: { method:'GET', isArray: false }
        });
    })

    .factory('DrugConceptService', function(DrugConcept) {
        return {

            /**
             * Fetches Drug Concepts
             *
             * @param params to search against
             * @returns $promise of array of matching Drugs (REST ref representation by default)
             */
            getDrugConcepts: function(params) {
                params.conceptClasses = "8d490dfc-c2cc-11de-8d13-0010c6dffd0f";
                return DrugConcept.query(params).$promise.then(function(res) {
                    return res.results;
                });
            }
        }
    });