@isTest
public with sharing class TestDataFactory {

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

        Shipment__c s = new Shipment__c(Name = 'test', FCL_LCL__c = 'FCL', Freight_Container__c = fcId);
        Database.SaveResult srS = Database.insert(s, false);
        String sId = srS.getId();

        Packing_checklist__c pc = new Packing_checklist__c(Freight_Container__c = fcId, ShipmentId__c = sId);
        Database.SaveResult srPc = Database.insert(pc, false);
        String pcId = srPc.getId();

        Map<String, String> idMap = new Map<String, String>();
        idMap.put('fcId', fcId);
        idMap.put('sId', sId);
        idMap.put('pcId', pcId);
        
        return idMap;
    }

}