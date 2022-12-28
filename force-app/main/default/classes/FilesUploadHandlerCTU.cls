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

    /**
     * It creates a folder to agregate CTU reference files and shall be called first.
     */
    @future
    public static void createWorkspace(){
        ContentWorkspace CTUWorkspace = new ContentWorkspace(
            Name='CTUcodeChecklistFiles', 
            DeveloperName='CTUcodeChecklistFiles');
        insert CTUWorkspace;
    }

    /**
     * @description It connects CTU reference files with their folder.
      shareType 'I' - Inferred permission. The user’s permission is determined by the related record.   
     * @param  contentId 
     */ 
    @future
    public static void addFilesToTheWorkspace(List<String> contentId){
        ContentWorkspace ws = [SELECT Id FROM ContentWorkspace WHERE Name = 'CTUcodeChecklistFiles' LIMIT 1];

        List<ContentDocumentLink> docLinks = new List<ContentDocumentLink>();
        for (String c : contentId) {
            docLinks.add(new ContentDocumentLink(
            contentDocumentId = c,
            linkedEntityId = ws.id,
            shareType = 'I',
            visibility = 'ALLUsers'        
            ));        
        }       
        insert docLinks;       

    }

}
