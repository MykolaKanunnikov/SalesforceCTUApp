public with sharing class QueueableFileUploadCTU implements Queueable, Database.AllowsCallouts{
    // This job should be done only once after deployment.
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
        Database.SaveResult[] srList = Database.insert(docVersions, false);

        //get id list of newly inserted content
        List<Id> docVersionsId = new List<Id>();
        for (Database.SaveResult sr : srList) {
            docVersionsId.add(sr.getId());
        }

        //get contentDocumentIds
        List<ContentVersion> content = [SELECT contentDocumentId 
                                        FROM ContentVersion
                                        WHERE Id IN :docVersionsId];


        //create, insert a record, that will be connected with files
        String baseChecklistEntityId = FilesUploadHandlerCTU.insertBaseChecklistEntity();
        
        //bulk connect of files and the base record
        //shareType 'I' - Inferred permission. The user’s permission is determined by the related record.   
        List<ContentDocumentLink> docLinks = new List<ContentDocumentLink>();
        for (ContentVersion c : content) {
            docLinks.add(new ContentDocumentLink(
                contentDocumentId = c.contentDocumentId,
                linkedEntityId = baseChecklistEntityId,
                shareType = 'I',
                visibility = 'ALLUsers'
            ));
        }
        insert docLinks;

    } catch (Exception e) {
        System.debug(e);
    }
    }
}
