public with sharing class PackingChecklistTriggerHandler {

    /**
     * @description checkNo populates the checkbox, which is needed for
     *  navigation through shipments (used in the "Checklist status" formula field)
     * @param  newChecklists 
     */
    public static void checkNo (List<Packing_checklist__c> newChecklists){
        for (Packing_checklist__c checklist : newChecklists) {
            Map<String, Object> fieldsToValue = checklist.getPopulatedFieldsAsMap();
            for (String fieldName : fieldsToValue.keySet()){
                 if(fieldsToValue.get(fieldName) == 'NO'){
                    checklist.Contains_NO__c = true;
                    break;
                 } else {
                    if (checklist.Contains_NO__c == true){
                        checklist.Contains_NO__c = false;
                    }
                 }
            }
        }
    }

}