public with sharing class ShipmentController {

    /**
     * @description It's a service method for click handler on every reference item
     * @param  title - value of a button data-id attribute (title / fileName)
     * @return        id of the proper .pdf file
     */ 
    @AuraEnabled(cacheable=true)
    public static String getFileRecordId(String title){      
        try {
            return [SELECT ContentDocumentId 
                    FROM ContentVersion
                    WHERE Title = :title AND Description = 'CTU Reference' 
                    LIMIT 1].ContentDocumentId;      
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

    }

    /**
     * @description It provides checklist id for further use
     * @param  recordId id of current freight container
     * @return          id of current checklist
     */
    @AuraEnabled
    public static String getCurrentChecklistId(String recordId){
        try {            
            String percentsRecordId = '%' + recordId + '%';
            return [SELECT Id, ShipmentId__c  
                    FROM Packing_checklist__c
                    WHERE ShipmentId__c LIKE :percentsRecordId].id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    /**
     * @description 
     * @param  currentChecklistId currentChecklistId description
     * @return                    return 
     */ 
    @AuraEnabled
    public static String getChecklistValues(String currentChecklistId){
        try {
            return '';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * @description It updates values of checklists
     * @param  currentChecklistId id of the proper object
     * @param  valueId            full name of the field to be updated
     * @param  value              'YES', 'NO' or 'N/A' string
     */
    @AuraEnabled
    public static void updateRadioValue(String currentChecklistId, String valueId, String value){
        try {
            String jsonString = '{"id": "' + currentChecklistId + '", "' + valueId + '": "' + value + '" }';
            Packing_checklist__c pc = (Packing_checklist__c)JSON.deserialize(jsonString, Packing_checklist__c.class);
            update pc;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}