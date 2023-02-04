@isTest
public with sharing class TestFreightContainerTriggerHandler {
    
    @isTest
    private static void testAvoidDuplicatesBeforeInsert(){
        TestDataFactory.insertFreightContainer('test');
        Test.startTest();
        Database.SaveResult srFc = TestDataFactory.insertFreightContainer('test');
        Test.stopTest();
        Assert.areEqual(false, srFc.isSuccess(), 'Duplicate occured');
    }

    @isTest
    private static void testavoidDuplicatesBeforeUpdate(){
        Database.SaveResult firstSr = TestDataFactory.insertFreightContainer('test1');
        TestDataFactory.insertFreightContainer('test2');
        Test.startTest();
        Freight_Container__c containerUpdate = new Freight_Container__c(
            Id = firstSr.getId(),
            Name = 'test2'
        );
        Database.SaveResult updateResult = Database.update(containerUpdate, false);
        Test.stopTest();
        Assert.areEqual(false, updateResult.isSuccess(), 'Unexpected freight container update (duplicate)');
    }
}