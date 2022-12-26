public with sharing class FilesUploadHandlerCTU {

    public List<String> names;

    /**
     * @description It reads description.json from the static resource.
     * Parsed data is needed to build references for static to files transmission process.
     * @return      return names of static resources.
     */ 
	public static List<String> parseDescriptionCTU() {
        List<String> descritionName = new List<String>{'description.json'};
        Map<String, Pagereference> descrtiptionUrl = getStaticResourceUrl(descritionName);
        Blob body = descrtiptionUrl.get(descritionName[0]).getContent();
        String json = body.toString();
        FilesUploadHandlerCTU fileNames = (FilesUploadHandlerCTU) System.JSON.deserialize(json, FilesUploadHandlerCTU.class);
        List<String> names = fileNames.names;
		return names;
	}


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
    public static Map<String, PageReference> getStaticResourceUrl(List<String> fileNames){
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
        Map<String, Pagereference> urlsMap = new Map<String, Pagereference>();
        for (String fileName : fileNames) {
            String srPath = '/resource/' + staticRes.SystemModstamp.getTime() + '/' + prefix + 'CTUref/' + fileName; 
            urlsMap.put(fileName, new PageReference(srPath));
        }
        return urlsMap;
    }

}
