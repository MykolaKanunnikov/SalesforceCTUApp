@isTest
public with sharing class TestShipmentController {

    @isTest
    private static void testGetFileRecordId(){
        String cvId = TestDataFactory.insertContentVersion();
        String cdId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cvId].ContentDocumentId;
        String txt = '/test.txt';

        Test.startTest();
        Response resp = ShipmentController.getFileRecordId(txt);
        Test.stopTest();

        Assert.areEqual(true, resp.isSuccess, 'Response success status is FALSE');
        Assert.areEqual(cdId, resp.responseObj, 'Expected ContentDocumentId is not recieved');
    }

    @isTest
    private static void negativeTestGetFileRecordId(){
        String txt = '/test.txt';
        Test.startTest();
        Response resp = ShipmentController.getFileRecordId(txt);
        Test.stopTest();
        Assert.areEqual(false, resp.isSuccess, 'Response success status is TRUE');
    }

    @isTest
    private static void testGetCurrentChecklistId(){
        Map<String, String> idMap = TestDataFactory.checklistSetup();
        Test.startTest();
        Response resp = ShipmentController.getCurrentChecklistId(idMap.get('sId'));
        Test.stopTest();
        Assert.areEqual(true, resp.isSuccess, 'Response success status is FALSE');
        Assert.areEqual(idMap.get('pcId'), resp.responseObj, 'Expected Packing_checklist__c is not recieved');
    }

    @isTest
    private static void negativeTestGetCurrentChecklistId(){
        Test.startTest();
        Response resp = ShipmentController.getCurrentChecklistId('0000001');
        Test.stopTest();
        Assert.areEqual(false, resp.isSuccess, 'Response success status is TRUE');
    }

    @isTest
    private static void testGetChecklistValues(){
        Map<String, String> idMap = TestDataFactory.checklistSetup();
        Test.startTest();
        Response resp = ShipmentController.getChecklistValues(idMap.get('pcId'), 'packingArea1__c');
        Test.stopTest();
        Assert.areEqual(true, resp.isSuccess, 'Response success status is FALSE');
    }

    @isTest
    private static void negativeTestGetChecklistValues(){
        Test.startTest();
        Response resp = ShipmentController.getChecklistValues('0000001', 'packingArea1__c');
        Test.stopTest();
        Assert.areEqual(false, resp.isSuccess, 'Response success status is TRUE');
    }

    @isTest
    private static void testUpdateRadioValue(){
        Map<String, String> idMap = TestDataFactory.checklistSetup();
        String pcId = idMap.get('pcId');
        Test.startTest();
        Response resp = ShipmentController.updateRadioValue(pcId, 'packingArea1__c', 'YES');
        Test.stopTest();
        Assert.areEqual(true, resp.isSuccess, 'Response success status is FALSE');
    }

    @isTest
    private static void negativeTestUpdateRadioValue(){
        Test.startTest();
        Response resp = ShipmentController.updateRadioValue('0000001', 'packingArea1__c', 'YES');
        Test.stopTest();
        Assert.areEqual(false, resp.isSuccess, 'Response success status is TRUE');
    }



}