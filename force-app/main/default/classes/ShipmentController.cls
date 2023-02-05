/**
 * @description The only controller in the app. Used in LWC
 */
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
            } else {
                properPdfId = [SELECT ContentDocumentId 
                               FROM ContentAsset
                               WHERE MasterLabel = :title AND NamespacePrefix = 'ctuapptest'
                               WITH SECURITY_ENFORCED 
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
             String currentChecklistId = [SELECT Id  
                                          FROM Packing_checklist__c
                                          WHERE Shipment__c =: recordId
                                          WITH SECURITY_ENFORCED].id;
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
     * @return                     success status or exception
     */
    @AuraEnabled
    public static Response updateRadioValue(String currentChecklistId, String valueId, String value){
        Response resp;
        try {
            String jsonString = '{"id": "' + currentChecklistId + '", "' + valueId + '": "' + value + '" }';
            Packing_checklist__c pc = (Packing_checklist__c)JSON.deserialize(jsonString, Packing_checklist__c.class);
            resp = new Response();
            Packing_checklist__c[] pcList = new Packing_checklist__c[]{pc};
            SObjectAccessDecision decision = Security.stripInaccessible(AccessType.UPDATABLE, pcList);
            update decision.getRecords();
        } catch (Exception e) {
            resp = new Response(e);
        }
        return resp;
    }

    /**
     * @description It instantiates an object, that contains icon-name
     * for checklistTabset LWC
     * @param  recordId 
     * @return          An object with fields representing one of 7 stages and containing icon-names
     */ 
    @AuraEnabled
    public static Response getIconMapObject(String recordId){
        Response resp;
        try {
            Packing_checklist__c pc = [SELECT Shipment__c, packingAreaDone__c, containerConditionDone__c, packingContainerDone__c, 
                                              dangerousGoodsDone__c, afterPackingDone__c, closingContainerDone__c, dispatchingContainerDone__c,
                                              packingAreaNo__c, containerConditionNo__c, packingContainerNo__c, dangerousGoodsNo__c, 
                                              afterPackingNo__c, closingContainerNo__c, dispatchingContainerNo__c 
                                       FROM Packing_checklist__c
                                       WHERE Shipment__c =: recordId
                                       WITH SECURITY_ENFORCED];
                                                
            IconMapper iconMapObject = new IconMapper(pc);
            resp = new Response(iconMapObject);
        } catch (Exception e) {
            resp = new Response(e);
        }
        return resp;
    }
}