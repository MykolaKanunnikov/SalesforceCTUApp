/**
 * @description Following methods encapsulate a whole ShipmentTrigger logic
 * @author Mykola Kanunnikov (Nick Eve)
 */ 
public with sharing class ShipmentTriggerHandler {

    //Shipment__c.Name means Master Bill of Lading (MBL) № or equivalent

    private static final String DUPLICATE_ERROR = 'No duplicates for already existing shipment-container pairs allowed';

    /**
     * @description It ensures that shipment-container pairs are unique.
     * @param  newShipments 
     */
    public static void avoidDuplicatesBeforeInsert(List<Shipment__c> newShipments){
        List<String> shipmentNames = new List<String>();
        List<String> shipmentContainers = new List<String>();
        for (Shipment__c shipment : newShipments) {
            shipmentNames.add(shipment.Name);
            shipmentContainers.add(shipment.Freight_Container__c);
        }
        List<Shipment__c> existingShipments = [SELECT Id
                                               FROM Shipment__c
                                               WHERE Name IN: shipmentNames
                                               AND Freight_Container__c IN: shipmentContainers
                                               WITH SECURITY_ENFORCED];
        if (!existingShipments.isEmpty()) {
            newShipments[0].addError(DUPLICATE_ERROR);
        }
    }

    /**
     * @description It ensures that shipment-container pairs are unique.
     * @param  newShipments
     * @param  oldShipments
     */
    public static void avoidDuplicatesBeforeUpdate(List<Shipment__c> newShipments, List<Shipment__c> oldShipments){
        List<String> newShipmentNames = new List<String>();
        List<String> newShipmentContainers = new List<String>();
        List<String> oldShipmentNames = new List<String>();
        List<String> oldShipmentContainers = new List<String>();
        for(Integer i = 0; i < newShipments.size(); i++){
            newShipmentNames.add(newShipments[i].Name);
            newShipmentContainers.add(newShipments[i].Freight_Container__c);
            oldShipmentNames.add(oldShipments[i].Name);
            oldShipmentContainers.add(oldShipments[i].Freight_Container__c);
        }
        if (!newShipmentNames.equals(oldShipmentNames) || !newShipmentContainers.equals(oldShipmentContainers)){ 
            List<Shipment__c> linkedShipments = [SELECT Id
                                                 FROM Shipment__c
                                                 WHERE Name IN: newShipmentNames
                                                 AND Freight_Container__c IN: newShipmentContainers
                                                 WITH SECURITY_ENFORCED];
            if (!linkedShipments.isEmpty()){
                newShipments[0].addError(DUPLICATE_ERROR);
            } 
        }
    }
    
    /**
     * @description createChecklist creates a Packing_checklist__c, which
     * we need as storage for values and relationships.
     * If goods are safety, corresponding checklist items shall be prepopulated
     * @param  newShipments list of new Shipmnent__c 
     */
    public static void createChecklist(List<Shipment__c> newShipments){
        List<Packing_checklist__c> pcList = new List<Packing_checklist__c>();
        String dangerousGoodsValue = 'N/A';
        for (Shipment__c shipment : newShipments) {
            if(shipment.Dangerous_goods__c){
                dangerousGoodsValue = '\'\'';
            }
            Packing_checklist__c pc = new Packing_checklist__c(
                Freight_Container__c = shipment.Freight_Container__c,
                Shipment__c = shipment.id,
                dangerousGoods20__c = dangerousGoodsValue,
                dangerousGoods21__c = dangerousGoodsValue,
                dangerousGoods22__c = dangerousGoodsValue,
                dangerousGoods23__c = dangerousGoodsValue
            );
            pcList.add(pc);
        }
        SObjectAccessDecision decision = Security.stripInaccessible(AccessType.CREATABLE, pcList);
        Database.SaveResult[] checklistSaveResult = Database.insert(decision.getRecords(), false);
        updateChecklistLink(checklistSaveResult, newShipments);
    }

    /**
     * @description handleNotDangerousGoodsBeforeUpdate fills
     * dangerous goods checklist items as "not applicable" for
     * safe goods and depopulates them for dangerous
     * @param  newShipments 
     * @param  oldShipments 
     */ 
    public static void handleNotDangerousGoodsBeforeUpdate(List<Shipment__c> newShipments, List<Shipment__c> oldShipments){
        List<Packing_checklist__c> pcForUpdate = new List<Packing_checklist__c>();
        List<Shipment__c> changedDangerousShipments = new List<Shipment__c>();
        for (Integer i = 0; i < newShipments.size(); i++){
            if(newShipments[i].Dangerous_goods__c != oldShipments[i].Dangerous_goods__c){
                changedDangerousShipments.add(newShipments[i]);
            }
        }
        List<Packing_checklist__c> detailChecklists = [SELECT Id, dangerousGoods20__c, dangerousGoods21__c, 
                                                       dangerousGoods22__c, dangerousGoods23__c
                                                       FROM Packing_checklist__c
                                                       WHERE Shipment__c IN: changedDangerousShipments
                                                       WITH SECURITY_ENFORCED];   
        String dangerousGoodsValue = 'N/A';
        for (Integer i = 0; i < detailChecklists.size(); i++) {
            if(changedDangerousShipments[i].Dangerous_goods__c){
                dangerousGoodsValue = '\'\'';
            }
            detailChecklists[i].dangerousGoods20__c = dangerousGoodsValue;
            detailChecklists[i].dangerousGoods21__c = dangerousGoodsValue;
            detailChecklists[i].dangerousGoods22__c = dangerousGoodsValue;
            detailChecklists[i].dangerousGoods23__c = dangerousGoodsValue;
            pcForUpdate.add(detailChecklists[i]);
        }  
        SObjectAccessDecision decision = Security.stripInaccessible(AccessType.UPDATABLE, pcForUpdate);
        Database.update(decision.getRecords(), false);
    }


    /**
     * @description It populates shipment-checklist lookup field
     * @param  checklistSaveResult 
     * @param  newShipments        
     */
    private static void updateChecklistLink (Database.SaveResult[] checklistSaveResult, List<Shipment__c> newShipments){
        List<Shipment__c> linkedShipments = new List<Shipment__c>();
            for (Integer i = 0; i < newShipments.size(); i++) {
                ctuapptest__Shipment__c linkedShipment = new ctuapptest__Shipment__c(
                    Id = newShipments[i].id,
                    Checklist__c = checklistSaveResult[i].getId());
                linkedShipments.add(linkedShipment);
            }
            SObjectAccessDecision decision = Security.stripInaccessible(AccessType.UPDATABLE, linkedShipments);
            Database.update(decision.getRecords(), false);
    }


}