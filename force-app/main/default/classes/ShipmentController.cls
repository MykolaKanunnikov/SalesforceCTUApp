public with sharing class ShipmentController {

    @AuraEnabled
    public static String getBaseUrl(){
        return URL.getSalesforceBaseUrl().toExternalForm();
    }

    /**
     * @description It's a service method for click handler on every reference item
     * @param  title - value of a button data-id attribute (title / fileName)
     * @return        id of the proper .pdf file
     */ 
    @AuraEnabled
    public static String getFileRecordId(String title){
        try {
        // Get record file IDs        
        List<Packing_checklist__c> pcList = [SELECT Id 
                                             FROM Packing_checklist__c];
        System.debug('pcList - ' + pcList);

        List<Id> pcIDs = new List<Id>();
        for (Packing_checklist__c pc : pcList) {
            pcIDs.add(pc.id);
        }
        List<ContentDocumentLink> files = [SELECT ContentDocumentId 
                                           FROM ContentDocumentLink 
                                           WHERE LinkedEntityId IN :pcIDs];
        
        System.debug('files - ' + files);

        List<Id> fileIDs = new List<Id>();
        for (ContentDocumentLink docLink : files) {
            fileIDs.add(docLink.ContentDocumentId);
        }

        System.debug('fileIDs - ' + fileIDs);

        // Filter PDF files 
        List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title 
                                     FROM ContentVersion 
                                     WHERE ContentDocumentId IN : fileIDs 
                                     AND FileExtension='pdf'
                                     AND Title=:title];
        System.debug('docs - ' + docs);

        String properPdfId = String.valueOf(docs[0].ContentDocumentId);
        System.debug('properPdfId - ' + properPdfId);
        return properPdfId;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}
