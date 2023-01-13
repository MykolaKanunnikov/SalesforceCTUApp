public with sharing class ShipmentController {

    /**
     * @description It's a service method for click handler on every reference item
     * If statement for testing is needed since NamespacePrefix is not writable.
     * @param  title - value of a button data-id attribute (title / fileName)
     * @return        id of the proper .pdf file
     */ 
    @AuraEnabled(cacheable=true)
    public static Response getFileRecordId(String title){      
        Response resp;
        try {
            String properPdfId;
            if(Test.isRunningTest()){
                properPdfId = [SELECT Id FROM ContentAsset WHERE MasterLabel = :title].id;
            }else{
                properPdfId = [SELECT ContentDocumentId 
                                      FROM ContentAsset
                                      WHERE MasterLabel = :title AND NamespacePrefix = 'ctuapptest' 
                                      LIMIT 1].ContentDocumentId;    
            }
            resp = new Response(properPdfId);
        } catch (Exception e) {
            resp = new Response(e);
        }
        return resp;
    }

    /**
     * @description It provides checklist id for further use
     * @param  recordId id of current freight container
     * @return          id of current checklist
     */
    @AuraEnabled
    public static Response getCurrentChecklistId(String recordId){
        Response resp;
        try {            
            String percentsRecordId = '%' + recordId + '%';
            // get id of related container for more precision
            String relatedContainerId = [SELECT Freight_Container__c
                                         FROM Shipment__c
                                         WHERE Id =:recordId].Freight_Container__c;

            String currentChecklistId = [SELECT Id  
                                         FROM Packing_checklist__c
                                         WHERE Freight_Container__c =:relatedContainerId
                                         AND ShipmentId__c LIKE :percentsRecordId].id;
            resp = new Response(currentChecklistId);
        } catch (Exception e) {
            resp = new Response(e);
        }
        return resp;
    }
    /**
     * @description It gives actual checklist values to display
     * @param  currentChecklistId id of the proper object 
     * @param fields              depends on calling component
     * @return                    actual checklist values to display 
     */ 
    @AuraEnabled
    public static Response getChecklistValues(String currentChecklistId, String fields){
        Response resp;
        try {
            // get values from database
            String query = 'SELECT ' + fields + ' FROM Packing_checklist__c WHERE Id =\'' + currentChecklistId + '\'';
            Packing_checklist__c values =  Database.query(query);
            resp = new Response(values);
        } catch (Exception e) {
            resp = new Response(e);
        }
        return resp;
    }

    /**
     * @description It updates values of checklists
     * @param  currentChecklistId id of the proper object
     * @param  valueId            full name of the field to be updated
     * @param  value              'YES', 'NO' or 'N/A' string
     */
    @AuraEnabled
    public static Response updateRadioValue(String currentChecklistId, String valueId, String value){
        Response resp;
        try {
            String jsonString = '{"id": "' + currentChecklistId + '", "' + valueId + '": "' + value + '" }';
            Packing_checklist__c pc = (Packing_checklist__c)JSON.deserialize(jsonString, Packing_checklist__c.class);
            resp = new Response();
            update pc;
        } catch (Exception e) {
            resp = new Response(e);
        }
        return resp;
    }
}