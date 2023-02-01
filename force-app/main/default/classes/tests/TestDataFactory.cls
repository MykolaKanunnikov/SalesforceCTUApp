@isTest
public with sharing class TestDataFactory {

    //ShipmentController
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

    public static String insertFreightContainer(){
        Freight_Container__c fc = new Freight_Container__c(Name = 'test');
        Database.SaveResult srFc = Database.insert(fc, false);
        String fcId = srFc.getId();
        return fcId;
    }

    public static Database.SaveResult insertShipment(String name, String freightContainer){
        Shipment__c s = new Shipment__c(Name = name, Freight_Container__c = freightContainer);
        Database.SaveResult srS = Database.insert(s, false);
        return srS;
    }






}