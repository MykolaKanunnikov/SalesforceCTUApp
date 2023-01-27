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
                                          WHERE Shipment__c =: recordId].id;
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

    /**
     * @description 
     * @param  recordId 
     * @return          
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
                                       WHERE Shipment__c =: recordId];
            
            String packingAreaValue = IconMapper.setIcon(pc.packingAreaDone__c, pc.packingAreaNo__c);
            String containerConditionValue = IconMapper.setIcon(pc.containerConditionDone__c, pc.containerConditionNo__c);
            String packingContainerValue = IconMapper.setIcon(pc.packingContainerDone__c, pc.packingContainerNo__c);
            String dangerousGoodsValue = IconMapper.setIcon(pc.dangerousGoodsDone__c, pc.dangerousGoodsNo__c);
            String afterPackingValue = IconMapper.setIcon(pc.afterPackingDone__c, pc.afterPackingNo__c);
            String closingContainerValue = IconMapper.setIcon(pc.closingContainerDone__c, pc.closingContainerNo__c);
            String dispatchingContainerValue = IconMapper.setIcon(pc.dispatchingContainerDone__c, pc.dispatchingContainerNo__c);
                                    
            IconMapper iconMapObject = new IconMapper(packingAreaValue, containerConditionValue, 
                                                        packingContainerValue, dangerousGoodsValue, 
                                                            afterPackingValue, closingContainerValue, 
                                                                dispatchingContainerValue);
            String json = JSON.serialize(iconMapObject);
            resp = new Response(json);
        } catch (Exception e) {
            resp = new Response(e);
        }
        return resp;
    }
}