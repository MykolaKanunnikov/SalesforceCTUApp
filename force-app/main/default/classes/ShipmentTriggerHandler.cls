public with sharing class ShipmentTriggerHandler {

    /**
     * @description createChecklist creates a Packing_checklist__c, which
     * we need as storage for values and relationships.
     * @param  newShipments list of new Shipmnent__c 
     */
    public static void createChecklist(List<ctuapptest__Shipment__c> newShipments){
        List<ctuapptest__Packing_checklist__c> pcList = new List<ctuapptest__Packing_checklist__c>();
        for (ctuapptest__Shipment__c shipment : newShipments) {
            ctuapptest__Packing_checklist__c pc = new ctuapptest__Packing_checklist__c(
                ctuapptest__Freight_Container__c = shipment.ctuapptest__Freight_Container__c,
                ctuapptest__ShipmentId__c = shipment.id
            );
            pcList.add(pc);
        }
        insert pcList;
    }

    /**
     * @description handleDelete removes unparented checklist records.
     * As parents here considered not only Freight_Containers but every
     * ShipmentId as well.
     * @param  oldShipments records snapshot before deletion
     */
    public static void handleDelete(List<ctuapptest__Shipment__c> oldShipments){
        List<String> sId = new List<String>();
        List<String> fcId = new List<String>();
        for (ctuapptest__Shipment__c shipment : oldShipments) {
            sId.add(shipment.id);
            fcId.add(shipment.ctuapptest__Freight_Container__c);
        }
        //FCL only
        List<ctuapptest__Packing_checklist__c> pcToDelete = [SELECT Id 
                                                             FROM ctuapptest__Packing_checklist__c
                                                             WHERE ctuapptest__Freight_Container__c IN :fcId
                                                             AND ShipmentId__c IN :sId];

        delete pcToDelete;
    }
}