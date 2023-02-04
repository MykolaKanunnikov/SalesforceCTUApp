@isTest
public with sharing class TestDataFactory {

    /**
     * @description insertContentAsset used in testGetFileRecordId
     * @return   return id of new ContentAsset instance 
     */
    public static String insertContentAsset(){
        ContentAsset ca = new ContentAsset(
            language = 'en_US',
            masterLabel = 'asset_testpdf',
            developerName = 'asset_testpdf'
        );
        Database.SaveResult srCa = Database.insert(ca, false);
        String caId = srCa.getId();
        return caId;
    }

    /**
     * @description checklistSetup inserts Freight_Container__c, and Shipment__c  
     * @return   custom objects id map
     */
    public static Map<String, String> checklistSetup(){
        Freight_Container__c fc = new Freight_Container__c(Name = 'test');
        Database.SaveResult srFc = Database.insert(fc, false);
        String fcId = srFc.getId();

        Shipment__c s = new Shipment__c(Name = 'test', Freight_Container__c = fcId);
        Database.SaveResult srS = Database.insert(s, false);
        String sId = srS.getId();

        String pcId = [SELECT Id FROM Packing_checklist__c WHERE Freight_Container__c =: fcId].id;

        Map<String, String> idMap = new Map<String, String>();
        idMap.put('fcId', fcId);
        idMap.put('sId', sId);
        idMap.put('pcId', pcId);
        
        return idMap;
    }

    /**
     * @description insert test FreightContainer__c
     * @param name FreightContainer__c.Name
     * @return   SaveResult object of test Freight_Container__c
     */
    public static Database.SaveResult insertFreightContainer(String name){
        Freight_Container__c fc = new Freight_Container__c(Name = name);
        Database.SaveResult srFc = Database.insert(fc, false);
        return srFc;
    }

    /**
     * @description insert test Shipment__c
     * @param  name             Shipment__c.Name
     * @param  freightContainer Shipment__c.FreightContainer__c
     * @return                  SaveResult object of test shipment
     */
    public static Database.SaveResult insertShipment(String name, String freightContainer){
        Shipment__c s = new Shipment__c(Name = name, Freight_Container__c = freightContainer);
        Database.SaveResult srS = Database.insert(s, false);
        return srS;
    }






}