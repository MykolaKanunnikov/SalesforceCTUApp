@isTest
public with sharing class TestDataFactory {

    public static String insertContentVersion(){
        String txt = '/test.txt';
        ContentVersion cv = new ContentVersion(
                ContentLocation = 'S',
                PathOnClient = txt,
                Title = txt,
                Description = 'CTU Reference',
                VersionData = Blob.valueOf(txt));
        Database.SaveResult sr = Database.insert(cv, false);
        String cvId = sr.getId();
        return cvId;
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