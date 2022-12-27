public with sharing class QueueableDeleteFilesCTU implements Queueable {
    /**
     * @description it's a way to automate files removal. It shall be more specific.
     * @param  context 
     */ 
    public void execute(QueueableContext context) {
    List<ContentDocument> cdList = [SELECT FileExtension
                                    FROM ContentDocument
                                    WHERE FileType = 'pdf'];

    delete cdList;
    }
}
