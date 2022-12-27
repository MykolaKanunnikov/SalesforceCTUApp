public with sharing class QueueableFileUploadCTU implements Queueable, Database.AllowsCallouts{
    // This job should be done only once after deployment.
    // ! change on batch
    public void execute(QueueableContext context) {
    try {
        //get names of files from static the resource
        List<String> fileNames = FilesUploadHandlerCTU.parseDescriptionCTU();

        //get names of static resource files connected to their URLs
        Map<String, PageReference> urlsMap = FilesUploadHandlerCTU.getStaticResourceUrl(fileNames);

        //pre-insert bulkification of content (files)
        //ContentLocation 'S' - document is located within Salesforce
        List<ContentVersion> docVersions = new List<ContentVersion>();
        for (String fileName : urlsMap.keySet()) {
            docVersions.add(new ContentVersion(
                ContentLocation = 'S',
                PathOnClient = fileName,
                Title = fileName,
                VersionData = urlsMap.get(fileName).getContent()
            ));    
        }
        Database.SaveResult[] docVersionsSrList = Database.insert(docVersions, false);

        //get id list of newly inserted content
        List<Id> docVersionsId = new List<Id>();
        for (Database.SaveResult sr : docVersionsSrList) {
            docVersionsId.add(sr.getId());
        }

        //get contentDocumentIds  
        List<ContentVersion> content = [SELECT contentDocumentId 
                                        FROM ContentVersion
                                        WHERE Id IN :docVersionsId];

        List<String> contentId = new List<Id>();
        for (ContentVersion c : content) {
            contentId.add(c.contentDocumentId);
        }
           
        // FilesUploadHandlerCTU.createWorkspace() should be called before the following, 
        // but in another context. 
        FilesUploadHandlerCTU.addFilesToTheWorkspace(contentId);


    } catch (Exception e) {
        System.debug(e);
    }
    }
}
