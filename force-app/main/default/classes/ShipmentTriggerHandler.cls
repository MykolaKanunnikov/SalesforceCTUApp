public with sharing class ShipmentTriggerHandler {

    //Shipment__c.Name means Master Bill of Lading (MBL)

    /**
     * @description It ensures that shipment-container pairs are unique.
     * @param  newShipments 
     */
    public static void avoidDuplicates(List<Shipment__c> newShipments){
        for (Shipment__c shipment : newShipments) {
            List<Shipment__c> existingShipments = [SELECT Id
                                                   FROM Shipment__c
                                                   WHERE Name = :shipment.Name
                                                   AND Freight_Container__c =:shipment.Freight_Container__c];

            if (!existingShipments.isEmpty()) {
                throw new IllegalArgumentException('No duplicates for already existing shipment-container pairs allowed');
            }
        }
    }
    
    /**
     * @description createChecklist creates a Packing_checklist__c, which
     * we need as storage for values and relationships.
     * @param  newShipments list of new Shipmnent__c 
     */
    public static void createChecklist(List<Shipment__c> newShipments){
        List<Packing_checklist__c> pcList = new List<Packing_checklist__c>();
        for (Shipment__c shipment : newShipments) {
                Packing_checklist__c pc = new Packing_checklist__c(
                    Freight_Container__c = shipment.Freight_Container__c,
                    ShipmentId__c = shipment.id
                );
                pcList.add(pc);
        }
        if(!pcList.isEmpty()){
            insert pcList;
        }
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