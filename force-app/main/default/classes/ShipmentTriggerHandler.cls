public with sharing class ShipmentTriggerHandler {

    /**
     * @description createChecklist creates a Packing_checklist__c, which
     * we need as storage for values and relationships.
     * @param  newShipments list of new Shipmnent__c 
     */
    public static void createChecklist(List<Shipment__c> newShipments){
        List<Packing_checklist__c> pcList = new List<Packing_checklist__c>();
        List<Shipment__c> lclShipments = new List<Shipment__c>();
        for (Shipment__c shipment : newShipments) {
            if(isFCL(shipment)){
                Packing_checklist__c pc = new Packing_checklist__c(
                    Freight_Container__c = shipment.Freight_Container__c,
                    ShipmentId__c = shipment.id
                );
                pcList.add(pc);
            } else {
                lclShipments.add(shipment);
            }
        }
        if(!pcList.isEmpty()){
            insert pcList;
        }
        if(!lclShipments.isEmpty()){
            upsertLclChecklist(lclShipments);
        }
    }

    private static void upsertLclChecklist(List<Shipment__c> lclShipments){
        //1 - check following:
        //1.1. - no undone checklists for this shipment in other containers
        //1.2. - this shipment is first
        List<Packing_checklist__c> pcList = new List<Packing_checklist__c>();
        for (Shipment__c shipment : lclShipments) {
            if(isLclReady(shipment)){
                //
                String lclId = '';
                String thisShipmentId = shipment.id + ', ';
                String shipmentsId = [SELECT ShipmentId__c 
                                      FROM Packing_checklist__c 
                                      WHERE Freight_Container__c =: lclShipment.Freight_Container__c
                                      AND ShipmentId__c LIKE :];

                Packing_checklist__c pc = new Packing_checklist__c(
                    id = 
                    Freight_Container__c = shipment.Freight_Container__c,
                    ShipmentId__c = //shipment.id
                );
                pcList.add(pc);

            }
        }
        


    }

    private static Boolean isLclReady(Shipment__c lclShipment){
        Boolean isLclReady = true;
        String lclId = '%' + lclShipment.id + '%';
        List<Packing_checklist__c> pcList = [SELECT Id 
                                             FROM Packing_checklist__c 
                                             WHERE Freight_Container__c =: lclShipment.Freight_Container__c
                                             AND ShipmentId__c LIKE :lclId];
        if (pcList.isEmpty()) {
            isLclReady = true;
        } else {
            List<Shipment__c> checkLclList = [SELECT Id 
                                              FROM Shipment__c 
                                              WHERE Master_Bill_of_Lading__c = :lclShipment.Master_Bill_of_Lading__c];
            for (Shipment__c shipment : checkLclList) {
                if(shipment.Is_Dispatched__c){
                    isLclReady = false;
                }
            }
            // lcl makes mbl field reqired
            // true - no dispatched shiments under the same mbl (validation rule)
        }
        return isLclReady;    
    }



    /**
     * @description handleDelete removes unparented checklist records.
     * As parents here considered not only Freight_Containers but every
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

        List<Id> pcToDelete;
        List<Shipment__c> lclShipments = new List<Shipment__c>();
        for (Shipment__c shipment : oldShipments) {
            if(isFCL(shipment)){
                Id tempPcToDelete = [SELECT Id 
                                     FROM Packing_checklist__c
                                     WHERE Freight_Container__c IN :fcId
                                     AND ShipmentId__c IN :sId].id;
            
                pcToDelete.add(tempPcToDelete);        
            } else {
                lclShipments.add(shipment);
            }
            
            if(!pcToDelete.isEmpty()) {
                Database.delete(pcToDelete, false);
            }

            if(!lclShipments.isEmpty()){
                deleteLCL(lclShipments);
            }

        }
    }

    private static Boolean isFCL(Shipment__c shipment){
        return shipment.FCL_LCL__c == 'FCL';
    }

    // todo after updating createChecklist
    private static void deleteLCL(List<Shipment__c> lclShipments){
        //1 - retrieve pc which contain shipmentId

        //2 - replace id with empty string

        //3 - if no id remains - delete pc

    }
}
