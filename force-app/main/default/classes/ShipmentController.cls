public with sharing class ShipmentController {

    @AuraEnabled
    public static String getBaseUrl(){
        return URL.getSalesforceBaseUrl().toExternalForm();
    }

}
