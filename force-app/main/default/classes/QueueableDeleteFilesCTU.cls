public with sharing class QueueableDeleteFilesCTU implements Queueable {
    /**
     * @description it's a way to automate files removal. It shall be more specific.
     * @param  context 
     */ 
    public void execute(QueueableContext context) {
    List<ContentDocument> cdList = [SELECT FileExtension, Description
                                    FROM ContentDocument
                                    WHERE FileType = 'pdf' AND Description = 'CTU Reference'];

    delete cdList;
    }
}
