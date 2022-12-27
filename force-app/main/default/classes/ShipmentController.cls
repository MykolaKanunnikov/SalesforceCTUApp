public with sharing class ShipmentController {

    @AuraEnabled(cacheable=true)
    public static String getBaseUrl(){
        return URL.getSalesforceBaseUrl().toExternalForm();
    }

    /**
     * @description It's a service method for click handler on every reference item
     * @param  title - value of a button data-id attribute (title / fileName)
     * @return        id of the proper .pdf file
     */ 
    @AuraEnabled(cacheable=true)
    public static String getFileRecordId(String title){      
        // + AND .pdf + add 'CTURef' to titles?
        return [SELECT ContentDocumentId FROM ContentVersion WHERE Title = :title LIMIT 1].ContentDocumentId;      
    }

}
