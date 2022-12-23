public with sharing class FilesUploadHandlerCTU {

    /**
     * @description Insert a record to be linked with reference files
     * @return  string of id of inserted record
     */ 
    public static String insertBaseChecklistEntity(){
        Packing_checklist__c baseChecklistEntity = new Packing_checklist__c();            
        Database.SaveResult saveRes = Database.insert(baseChecklistEntity, false);
        String baseChecklistEntityId = String.valueOf(saveRes.getId());
        return baseChecklistEntityId;
    }

    /**
     * @description Get a link to the static resource
     * @return   PageReference
     */
    public static PageReference getStaticResourceUrl(){
        StaticResource staticRes = [SELECT Id, NamespacePrefix, SystemModstamp  
                                    FROM StaticResource 
                                    WHERE Name = 'CTUref' 
                                    LIMIT 1];
        String prefix = staticRes.NamespacePrefix;    
        if(String.isEmpty(prefix) ) {
            prefix = '';
        } else {
        //If has NamespacePrefix
        prefix += '__';
        }
        //Get the path of the file in Zip static resource
        String fileName = '1.pdf';
        String srPath = '/resource/' + staticRes.SystemModstamp.getTime() + '/' + prefix + 'CTUref/' + fileName; 
        PageReference pg = new PageReference(srPath);
        return pg;
    }


    
}
