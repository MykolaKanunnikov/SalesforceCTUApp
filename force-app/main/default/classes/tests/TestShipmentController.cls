/**
 * @author Mykola Kanunnikov (Nick Eve)
 */

@isTest
public with sharing class TestShipmentController {

    @isTest
    private static void testGetFileRecordId(){
        String caId = TestDataFactory.insertContentAsset();
        String masterLabel = 'asset_testpdf';
        Test.startTest();
        Response resp = ShipmentController.getFileRecordId(masterLabel);
        Test.stopTest();
        Assert.areEqual(true, resp.isSuccess, 'Response success status is FALSE');
        Assert.areEqual(caId, resp.responseObj, 'Expected ContentAsset Id is not recieved');
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
        Response resp = ShipmentController.getChecklistValues(idMap.get('pcId'), 'packingArea');
        Test.stopTest();
        Assert.areEqual(true, resp.isSuccess, 'Response success status is FALSE');
    }

    @isTest
    private static void negativeTestGetChecklistValues(){
        Test.startTest();
        Response resp = ShipmentController.getChecklistValues('0000001', 'packingArea');
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
    
    @IsTest
    static void testUpdateChecklistValuesSuccess() {
        Map<String, Id> idMap = TestDataFactory.checklistSetup();
        String pcId = idMap.get('pcId');
        Map<String, String> valuesToUpdate = new Map<String, String>{
        'packingArea1__c' => 'YES',
        'packingArea2__c' => 'NO',
        'packingArea3__c' => 'YES'
        };
        Test.startTest();
        Response resp = ShipmentController.updateChecklistValues(pcId,valuesToUpdate);
        Test.stopTest();
    }


    @isTest
    private static void testGetIconMapObject(){
        Map<String, String> idMap = TestDataFactory.checklistSetup();
        String sId = idMap.get('sId');

        Test.startTest();
        Response resp = ShipmentController.getIconMapObject(sId);
        Test.stopTest();
        
        String str = JSON.serialize(resp.responseObj);
        Boolean containsWarning = str.contains('warning');
        Boolean containsSuccess = str.contains('success');
        Assert.areEqual(false, containsWarning, '"Warning" is not expected');
        Assert.areEqual(true, containsSuccess, 'No "Success", but expected');
    }

}