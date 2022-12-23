public with sharing class QueueableFileUploadCTU implements Queueable, Database.AllowsCallouts{
    public void execute(QueueableContext context) {
    try {

        PageReference pg = FilesUploadHandlerCTU.getStaticResourceUrl();
        Blob body = pg.getContent();
        String fileName = '1.pdf';
        String baseChecklistEntityId = FilesUploadHandlerCTU.insertBaseChecklistEntity();


        //
        ContentVersion docVer = new ContentVersion();
        docVer.ContentLocation = 'S';
        docVer.PathOnClient = fileName;
        docVer.Title = fileName;
        docVer.VersionData = body;
        insert docVer;

        String versionId = [SELECT contentDocumentId 
                            FROM contentVersion
                            WHERE Id =:docVer.id].contentDocumentId;
        
        System.debug(versionId);

        ContentDocumentLink docLink = new ContentDocumentLink();
        docLink.contentDocumentId = versionId;
        docLink.linkedEntityId = baseChecklistEntityId;
        docLink.shareType = 'I';
        docLink.visibility = 'ALLUsers';
        insert docLink;

    } catch (Exception e) {
        System.debug(e);
    }
    }
}
