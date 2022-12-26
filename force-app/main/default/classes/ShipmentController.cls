public with sharing class ShipmentController {

    @AuraEnabled
    public static String getBaseUrl(){
        return URL.getSalesforceBaseUrl().toExternalForm();
    }

    @AuraEnabled
    public static String getFileRecordId(String itemId){
        try {
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}
