@isTest
public with sharing class TestShipmentTriggerHandler {

    @isTest
    private static void testAvoidDuplicatesBeforeInsert(){
        String fcId = TestDataFactory.insertFreightContainer();
        Database.SaveResult firstSr = TestDataFactory.insertShipment('test', fcId);
        Test.startTest();
        Database.SaveResult secondSr = TestDataFactory.insertShipment('test', fcId);
        Test.stopTest();
        Assert.areEqual(true, firstSr.isSuccess(), 'First test shipment was not inserted');
        Assert.areEqual(false, secondSr.isSuccess(), 'Duplicate occured');
    }

    @isTest
    private static void testAvoidDuplicatesBeforeUpdate(){
        String fcId = TestDataFactory.insertFreightContainer();
        Database.SaveResult firstSr = TestDataFactory.insertShipment('test1', fcId);
        TestDataFactory.insertShipment('test2', fcId);
        Test.startTest();
        Shipment__c shipmentUpdate = new Shipment__c(
            Id = firstSr.getId(),
            Name = 'test2'
        );
        Database.SaveResult updateResult = Database.update(shipmentUpdate, false);
        Test.stopTest();
        Assert.areEqual(false, updateResult.isSuccess(), 'Unexpected shipment update (duplicate)');
    }

    @isTest
    private static void testHandleNotDangerousGoodsBeforeUpdate(){
        Map<String, String> idMap = TestDataFactory.checklistSetup();
        String sId = idMap.get('sId');
        Test.startTest();
        Shipment__c shipmentUpdate = new Shipment__c(
            Id = sId,
            Dangerous_goods__c = true
        );
        Database.update(shipmentUpdate, false);
        Test.stopTest();
        Packing_checklist__c pc = [SELECT dangerousGoodsDone__c FROM Packing_checklist__c WHERE Shipment__c =:sId];
        Assert.areEqual(false, pc.dangerousGoodsDone__c, 'Dangerous goods stage should not be done');
    }
}