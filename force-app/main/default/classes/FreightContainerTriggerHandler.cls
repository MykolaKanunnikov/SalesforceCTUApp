/**
 * @description Following methods encapsulate a whole FreightContainerTrigger logic
 */ 
public with sharing class FreightContainerTriggerHandler {

    private static final String DUPLICATE_ERROR = 'No freight container duplicates allowed';

    /**
     * @description It ensures that containers are unique.
     * @param  newContainers 
     */
    public static void avoidDuplicatesBeforeInsert(List<Freight_Container__c> newContainers){
        List<String> namesList = new List<String>();
        for (Freight_Container__c container : newContainers) {
            namesList.add(container.name);
        }
        List<Freight_Container__c> fcSameNameList = [SELECT Name
                                                     FROM Freight_Container__c
                                                     WHERE Name IN: namesList
                                                     WITH SECURITY_ENFORCED];
        if(!fcSameNameList.isEmpty()){
            newContainers[0].addError(DUPLICATE_ERROR);
        }  
    }

    /**
     * @description It ensures that containers are unique.
     * @param  newContainers
     * @param  oldContainers
     */
    public static void avoidDuplicatesBeforeUpdate(List<Freight_Container__c> newContainers, List<Freight_Container__c> oldContainers){
        List<String> newNamesList = new List<String>();
        List<String> oldNamesList = new List<String>();
        for (Integer i = 0; i < newContainers.size(); i++) {
            newNamesList.add(newContainers[i].Name);
            oldNamesList.add(oldContainers[i].Name);
        }
        if(!newNamesList.equals(oldNamesList)){
            List<Freight_Container__c> fcSameNameList = [SELECT Name
                                                         FROM Freight_Container__c
                                                         WHERE Name IN: newNamesList
                                                         WITH SECURITY_ENFORCED];
            if(!fcSameNameList.isEmpty()){
                newContainers[0].addError(DUPLICATE_ERROR);
            }  
        }
    }

}