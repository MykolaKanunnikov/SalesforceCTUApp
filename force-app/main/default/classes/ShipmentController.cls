public with sharing class ShipmentController {

    /**
     * @description It's a service method for click handler on every reference item
     * @param  title - value of a button data-id attribute (title / fileName)
     * @return        id of the proper .pdf file
     */ 
    @AuraEnabled(cacheable=true)
    public static String getFileRecordId(String title){      
        return [SELECT ContentDocumentId 
                FROM ContentVersion
                WHERE Title = :title AND Description = 'CTU Reference' 
                LIMIT 1].ContentDocumentId;      
    }

}
