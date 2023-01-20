public with sharing class ShipmentTriggerHandler {

    //Shipment__c.Name means Master Bill of Lading (MBL)

    /**
     * @description createChecklist creates a Packing_checklist__c, which
     * we need as storage for values and relationships.
     * @param  newShipments list of new Shipmnent__c 
     */
    public static void createChecklist(List<Shipment__c> newShipments){
        List<Packing_checklist__c> pcList = new List<Packing_checklist__c>();
        List<Shipment__c> lclShipments = new List<Shipment__c>();
        for (Shipment__c shipment : newShipments) {
           // if(isFCL(shipment)){
                Packing_checklist__c pc = new Packing_checklist__c(
                    Freight_Container__c = shipment.Freight_Container__c,
                    ShipmentId__c = shipment.id
                );
                pcList.add(pc);
         //   } else {
                lclShipments.add(shipment);
           // }
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
        List<Packing_checklist__c> pcListForInsert = new List<Packing_checklist__c>();
        List<Packing_checklist__c> pcListForUpdate = new List<Packing_checklist__c>();
        for (Shipment__c shipment : lclShipments) {
      //      if(isLclReady(shipment)){
                // select lcl shipments under same mbl and container
                List<Shipment__c> lclShipmentsGroup = [SELECT Id, Name
                                                       FROM Shipment__c 
                                                       WHERE Name = :shipment.Name
                                                       AND Freight_Container__c = :shipment.Freight_Container__c];
                // if the lclShipmentsGroup is empty, no proper checklist exists. Then insert new checklist. 
                if(lclShipmentsGroup.isEmpty()){
                    Packing_checklist__c pc = new Packing_checklist__c(
                        Freight_Container__c = shipment.Freight_Container__c,
                        ShipmentId__c = shipment.id
                    );
                    pcListForInsert.add(pc);
        //        } else {
                    // Only one checklist shall correspond to one LCL shipment group.

                    // Select the checklist that contains LCL ids.
                 //   Packing_checklist__c updateableLclChecklist = getUpdateableLclChecklist(shipment);
                    // Create a checklist object for update 
                //    Packing_checklist__c checklistForUpdate = 
                 //   pcListForUpdate.add(pc);               
        //        }
            }
        }
        insert pcListForInsert;
        update pcListForUpdate;
    }

    /*
    private static Packing_checklist__c getUpdateableLclChecklist(Shipment__c shipment){
        List <Packing_checklist__c> pcList = [SELECT Id, ShipmentId__c, ShipmentId1__c, ShipmentId2__c, ShipmentId3__c, 
                                              ShipmentId4__c, ShipmentId5__c, ShipmentId6__c, ShipmentId7__c, 
                                              ShipmentId8__c, ShipmentId9__c 
                                              FROM Packing_checklist__c
                                              WHERE ShipmentId__c =: shipment.id
                                              OR ShipmentId1__c =: shipment.id
                                              OR ShipmentId2__c =: shipment.id
                                              OR ShipmentId3__c =: shipment.id
                                              OR ShipmentId4__c =: shipment.id
                                              OR ShipmentId5__c =: shipment.id
                                              OR ShipmentId6__c =: shipment.id
                                              OR ShipmentId7__c =: shipment.id
                                              OR ShipmentId8__c =: shipment.id
                                              OR ShipmentId9__c =: shipment.id];
        
        Packing_checklist__c updateableLclChecklist = [SELECT Id
                                                       FROM Packing_checklist__c
                                                       WHERE Id IN :pcListByContainer
                                                       AND Freight_Container__c =: shipment.Freight_Container__c]; 

        return updateableLclChecklist;
    }


    private static Packing_checklist__c getChecklistForUpdate(Packing_checklist__c updateableLclChecklist){
        for (Integer i = 0; i < 10; i++) {
            
        }

        if(String.isBlank(updateableLclChecklist.ShipmentId1__c))
        Packing_checklist__c checklistForUpdate = new Packing_checklist__c(
            id = updateableLclChecklist.id,
            ShipmentId__c = n
        );

    }
*/
/*
    private static Boolean isLclReady(Shipment__c lclShipment){
        Boolean isLclReady = true;
        String lclId = '%' + lclShipment.id + '%';
        // check whether checklist for this shipment already exists. If so, check following.
        // It is done to avoid duplicates         
        List<Packing_checklist__c> pcList = [SELECT Id 
                                             FROM Packing_checklist__c 
                                             WHERE ShipmentId__c LIKE :lclId];
        if (!pcList.isEmpty()) {
            isLclReady = false;
        } else {
            // check whether checklist for shipments under this MBL and mentioned container already exists
            List<Shipment__c> checkLclList = [SELECT Id, Is_Dispatched__c 
                                              FROM Shipment__c 
                                              WHERE Freight_Container__c = :lclShipment.Freight_Container__c];
                                              // WHERE Master_Bill_of_Lading__c = :lclShipment.Master_Bill_of_Lading__c
                                              // AND Freight_Container__c = :lclShipment.Freight_Container__c];
            for (Shipment__c shipment : checkLclList) {
                // already dispatched shipments shall be immutable
                if(shipment.Is_Dispatched__c){
                    isLclReady = false;
                }
            }
            // lcl makes mbl field reqired
            // true - no dispatched shiments under the same mbl (validation rule)
        }
        return isLclReady;    
    }
*/


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
         //   if(isFCL(shipment)){
                Id tempPcToDelete = [SELECT Id 
                                     FROM Packing_checklist__c
                                     WHERE Freight_Container__c IN :fcId
                                     AND ShipmentId__c IN :sId].id;
            
                pcToDelete.add(tempPcToDelete);        
     //       } else {
                lclShipments.add(shipment);
       //     }
            
            if(!pcToDelete.isEmpty()) {
                Database.delete(pcToDelete, false);
            }

            if(!lclShipments.isEmpty()){
                deleteLCL(lclShipments);
            }

        }
    }
/*
    private static Boolean isFCL(Shipment__c shipment){
        return shipment.FCL_LCL__c == 'FCL';
    }
    */

    // todo after updating createChecklist
    private static void deleteLCL(List<Shipment__c> lclShipments){
        //1 - retrieve pc which contain shipmentId

        //2 - replace id with empty string

        //3 - if no id remains - delete pc

    }
}