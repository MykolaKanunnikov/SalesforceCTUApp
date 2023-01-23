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
                throw new IllegalArgumentException(
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
                    throw new IllegalArgumentException(
                        'No duplicates for already existing shipment-container pairs allowed');
                } else {
                    createChecklistBeforeUpdate(newShipments[i]);
                }
            }
        }
    }
    
    /**
     * @description createChecklist creates a Packing_checklist__c, which
     * we need as storage for values and relationships.
     * @param  newShipments list of new Shipmnent__c 
     */
    public static void createChecklistAfterInsert(List<Shipment__c> newShipments){
        List<Packing_checklist__c> pcList = new List<Packing_checklist__c>();
        for (Shipment__c shipment : newShipments) {
                Packing_checklist__c pc = new Packing_checklist__c(
                    Freight_Container__c = shipment.Freight_Container__c,
                    ShipmentId__c = shipment.id
                );
                pcList.add(pc);
        }
        Database.SaveResult[] checklistSaveResult = Database.insert(pcList, false);
        updateChecklistLink(checklistSaveResult, newShipments);
    }

    private static void createChecklistBeforeUpdate(Shipment__c shipmentBeforeUpdate){
        Packing_checklist__c pc = new Packing_checklist__c(
            Freight_Container__c = shipmentBeforeUpdate.Freight_Container__c,
            ShipmentId__c = shipmentBeforeUpdate.id
        );      
        Database.SaveResult checklistSaveResult = Database.insert(pc, false);
        System.debug('checklistSaveResult - ' + checklistSaveResult);
        updateChecklistLink(checklistSaveResult, shipmentBeforeUpdate);

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

    private static void updateChecklistLink (Database.SaveResult checklistSaveResult, Shipment__c newShipment){
        ctuapptest__Shipment__c linkedShipment = new ctuapptest__Shipment__c(
            Id = newShipment.id,
            Checklist__c = checklistSaveResult.getId());
        Database.SaveResult linkedShipmentSaveResult = Database.update(linkedShipment, false);
        System.debug('linkedShipmentSaveResult - ' + linkedShipmentSaveResult);
    }



    private static Boolean isNameContainerChanged (Shipment__c newShipment, Shipment__c oldShipment){
        return newShipment.Name != oldShipment.Name  
        ||  newShipment.Freight_Container__c != oldShipment.Freight_Container__c;
    }

    /**
     * @description handleDelete removes unparented checklist records.
     * As parents here considered not only Freight_Containers but 
     * ShipmentId as well.
     * @param  oldShipments records snapshot before deletion
     */
    public static void handleDelete(List<Shipment__c> oldShipments){
        List<String> sId = new List<String>();
        List<String> fcId = new List<String>();
        for (Shipment__c shipment : oldShipments) {
            sId.add(shipment.id);
            fcId.add(shipment.Freight_Container__c);
        }
        List<Id> pcToDelete = new List<Id>();
        try {
            for (Shipment__c shipment : oldShipments) {
                Id tempPcToDelete = [SELECT Id 
                                     FROM Packing_checklist__c
                                     WHERE Freight_Container__c IN :fcId
                                     AND ShipmentId__c IN :sId].id;
            
                pcToDelete.add(tempPcToDelete);        
            }
        } catch (Exception e) {
            e.getMessage();
        } finally {
        if(!pcToDelete.isEmpty()) {
            Database.delete(pcToDelete, false);
        }
    }
}

}