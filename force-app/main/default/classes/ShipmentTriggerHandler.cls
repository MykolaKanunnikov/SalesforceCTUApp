public with sharing class ShipmentTriggerHandler {

    //Shipment__c.Name means Master Bill of Lading (MBL)

    /**
     * @description It ensures that shipment-container pairs are unique.
     * @param  newShipments 
     */
    public static void avoidDuplicatesBeforeInsert(List<Shipment__c> newShipments){
        for (Shipment__c shipment : newShipments) {
            List<Shipment__c> existingShipments = [SELECT Id
                                                   FROM Shipment__c
                                                   WHERE Name = :shipment.Name
                                                   AND Freight_Container__c =:shipment.Freight_Container__c];
            if (!existingShipments.isEmpty()) {
                shipment.addError(
                    'No duplicates for already existing shipment-container pairs allowed');
            }
        }    
    }

    public static void avoidDuplicatesBeforeUpdate(List<Shipment__c> newShipments, List<Shipment__c> oldShipments){
        for(Integer i = 0; i < newShipments.size(); i++){
            if (isNameContainerChanged(newShipments[i], oldShipments[i])){ 
                List<Shipment__c> linkedShipments = [SELECT Id
                                                     FROM Shipment__c
                                                     WHERE Name =: newShipments[i].Name
                                                     AND Freight_Container__c =: newShipments[i].Freight_Container__c];
                if (!linkedShipments.isEmpty()){
                    newShipments[i].addError(
                        'No duplicates for already existing shipment-container pairs allowed');
                } 
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
        Database.SaveResult[] checklistSaveResult = Database.insert(pcList, false);
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
        for (Integer i = 0; i < newShipments.size(); i++){
            if(newShipments[i].Dangerous_goods__c != oldShipments[i].Dangerous_goods__c){
                Packing_checklist__c detailChecklist = [SELECT Id, dangerousGoods20__c, dangerousGoods21__c, 
                                                                    dangerousGoods22__c, dangerousGoods23__c
                                                        FROM Packing_checklist__c
                                                        WHERE Shipment__c = :newShipments[i].id];
                String dangerousGoodsValue = 'N/A';
                if(newShipments[i].Dangerous_goods__c){
                    dangerousGoodsValue = '\'\'';
                }
                detailChecklist.dangerousGoods20__c = dangerousGoodsValue;
                detailChecklist.dangerousGoods21__c = dangerousGoodsValue;
                detailChecklist.dangerousGoods22__c = dangerousGoodsValue;
                detailChecklist.dangerousGoods23__c = dangerousGoodsValue;
                pcForUpdate.add(detailChecklist);
            }
            if(!pcForUpdate.isEmpty()){
                update pcForUpdate;
            }
        }
    }


    private static Boolean isNameContainerChanged (Shipment__c newShipment, Shipment__c oldShipment){
        return newShipment.Name != oldShipment.Name  
        ||  newShipment.Freight_Container__c != oldShipment.Freight_Container__c;
    }

    private static void updateChecklistLink (Database.SaveResult[] checklistSaveResult, List<Shipment__c> newShipments){
        List<Shipment__c> linkedShipments = new List<Shipment__c>();
            for (Integer i = 0; i < newShipments.size(); i++) {
                ctuapptest__Shipment__c linkedShipment = new ctuapptest__Shipment__c(
                    Id = newShipments[i].id,
                    Checklist__c = checklistSaveResult[i].getId());
                    linkedShipments.add(linkedShipment);
            }
        Database.SaveResult[] linkedShipmentsSaveResult = Database.update(linkedShipments, false);
}




}