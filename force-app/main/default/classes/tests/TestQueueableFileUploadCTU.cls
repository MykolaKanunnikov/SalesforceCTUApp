@isTest
public with sharing class TestQueueableFileUploadCTU {
   
    //Skip the Blob content in test class
    @isTest(SeeAllData=true)
    private static void testQueueableFileUploadCTU(){
        System.enqueueJob(new QueueableFileUploadCTU());
    }
}