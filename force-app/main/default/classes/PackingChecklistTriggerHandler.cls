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

    /**
     * @description handleNotDangerousGoods automatically fills
     * dangerous goods checklist items as "not applicable" for
     * safe goods
     * @param  newChecklists newChecklists description
     */
    public static void handleNotDangerousGoods(List<Packing_checklist__c> newChecklists){
        for (Packing_checklist__c checklist : newChecklists) {
            Shipment__c masterShipment = [SELECT Id, Dangerous_goods__c
                                          FROM Shipment__c
                                          WHERE Id = :checklist.Shipment__c];
        if (masterShipment.Dangerous_goods__c){
            checklist.dangerousGoods20__c = 'N/A';
            checklist.dangerousGoods21__c = 'N/A';
            checklist.dangerousGoods22__c = 'N/A';
            checklist.dangerousGoods23__c = 'N/A';
        }
        }
    }


}