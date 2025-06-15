/**
 * @description The only controller in the app. Used in LWC
 * @author Mykola Kanunnikov (Nick Eve)
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
     * The method is so long since dynamic query is not used to avoid SOQL injections
     * @param  currentChecklistId id of the proper object 
     * @param fields              depends on calling component
     * @return                    actual checklist values to display 
     */ 
    @AuraEnabled
    public static Response getChecklistValues(String currentChecklistId, String fields){
        Response resp;
        try {
            Packing_checklist__c values = null;
            if(fields == 'packingArea'){
                values = [SELECT ctuapptest__packingArea1__c, ctuapptest__packingArea2__c, 
                                 ctuapptest__packingArea3__c, ctuapptest__packingArea4__c, 
                                 ctuapptest__packingArea5__c, ctuapptest__packingArea6__c, 
                                 ctuapptest__packingArea7__c
                          FROM Packing_checklist__c
                          WHERE Id =: currentChecklistId
                          WITH SECURITY_ENFORCED];
            } else if (fields == 'containerCondition'){
                values = [SELECT ctuapptest__containerCondition8__c, ctuapptest__containerCondition9__c, 
                                 ctuapptest__containerCondition10__c , ctuapptest__containerCondition11__c,
                                 ctuapptest__containerCondition12__c
                          FROM Packing_checklist__c
                          WHERE Id =: currentChecklistId
                          WITH SECURITY_ENFORCED];                
            } else if (fields == 'packingContainer'){
                values = [SELECT ctuapptest__packingContainer13__c, ctuapptest__packingContainer14__c, 
                                 ctuapptest__packingContainer15__c, ctuapptest__packingContainer16__c, 
                                 ctuapptest__packingContainer17__c, ctuapptest__packingContainer18__c, 
                                 ctuapptest__packingContainer19__c
                          FROM Packing_checklist__c
                          WHERE Id =: currentChecklistId
                          WITH SECURITY_ENFORCED];                
            } else if (fields == 'dangerousGoods'){
                values = [SELECT ctuapptest__dangerousGoods20__c, ctuapptest__dangerousGoods21__c, 
                                 ctuapptest__dangerousGoods22__c, ctuapptest__dangerousGoods23__c
                          FROM Packing_checklist__c
                          WHERE Id =: currentChecklistId
                          WITH SECURITY_ENFORCED];                
            } else if (fields == 'afterPacking'){
                values = [SELECT ctuapptest__afterPacking24__c, ctuapptest__afterPacking25__c, 
                                 ctuapptest__afterPacking26__c, ctuapptest__afterPacking27__c
                          FROM Packing_checklist__c
                          WHERE Id =: currentChecklistId
                          WITH SECURITY_ENFORCED];                
            } else if (fields == 'closingContainer'){
                values = [SELECT ctuapptest__closingContainer28__c, ctuapptest__closingContainer29__c
                          FROM Packing_checklist__c
                          WHERE Id =: currentChecklistId
                          WITH SECURITY_ENFORCED];                
            } else if (fields == 'dispatchingContainer'){
                values = [SELECT ctuapptest__dispatchingContainer30__c, ctuapptest__dispatchingContainer31__c, 
                                 ctuapptest__dispatchingContainer32__c, ctuapptest__dispatchingContainer33__c, 
                                 ctuapptest__dispatchingContainer34__c
                          FROM Packing_checklist__c
                          WHERE Id =: currentChecklistId
                          WITH SECURITY_ENFORCED];                
            }
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

@AuraEnabled
public static Response updateChecklistValues(String checklist, Map<String, String> values) {
    Response resp = new Response();
    try {
        Packing_checklist__c pc = new Packing_checklist__c(Id = checklist);
        for (String key : values.keySet()) {
            pc.put(key, values.get(key));
        }
        SObjectAccessDecision decision = Security.stripInaccessible(AccessType.UPDATABLE, new List<Packing_checklist__c>{pc});
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