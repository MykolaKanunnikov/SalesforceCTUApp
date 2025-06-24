public with sharing class ChecklistDataWrapper {
    @AuraEnabled
    public String section { get; set; }
    
    @AuraEnabled
    public String icon { get; set; }
    
    @AuraEnabled
    public String label { get; set; }
    
    @AuraEnabled
    public List<CheckListItemsWrapper> items { get; set; }
    
    public ChecklistDataWrapper(String section, String icon, String label, List<CheckListItemsWrapper> itemsList) {
        this.section = section;
        this.icon = icon;
        this.label = label;
        this.items = itemsList;
    }
    
    @AuraEnabled
    public static Response getChecklistData(Id recordId) {
        Response resp;
        try {
            List<ChecklistDataWrapper> data = new List<ChecklistDataWrapper>();
            Packing_checklist__c checklist = [SELECT Shipment__c, packingAreaDone__c, containerConditionDone__c, packingContainerDone__c, 
                                              dangerousGoodsDone__c, afterPackingDone__c, closingContainerDone__c, dispatchingContainerDone__c,
                                              packingAreaNo__c, containerConditionNo__c, packingContainerNo__c, dangerousGoodsNo__c, 
                                              afterPackingNo__c, closingContainerNo__c, dispatchingContainerNo__c 
                                       FROM Packing_checklist__c
                                       WHERE Shipment__c =: recordId
                                       WITH SECURITY_ENFORCED];
            List<CheckListItemsWrapper> items = new List<CheckListItemsWrapper>();
            ChecklistDataWrapper packingArea = new ChecklistDataWrapper(
                'packingArea',
            setIcon(checklist.packingAreaDone__c, checklist.packingAreaNo__c),
            '1. The packing area',
            CheckListItemsWrapper.returnPackingAreaData());
            
            ChecklistDataWrapper containerCondition = new ChecklistDataWrapper(
                'containerCondition',
            setIcon(checklist.containerConditionDone__c, checklist.containerConditionNo__c),
            '2. Container condition',
            CheckListItemsWrapper.returnContainerConditionData());
            
            ChecklistDataWrapper packingContainer = new ChecklistDataWrapper(
                'packingContainer',
            setIcon(checklist.packingContainerDone__c,checklist.packingContainerNo__c),
            '3. Packing the container',
            CheckListItemsWrapper.returnPackingContainerData());
            
            ChecklistDataWrapper dangerousGoods = new ChecklistDataWrapper(
                'dangerousGoods',
            setIcon(checklist.dangerousGoodsDone__c, checklist.dangerousGoodsNo__c),
            '4. Dangerous goods',
            CheckListItemsWrapper.returnDangerousGoodsData());
            
            ChecklistDataWrapper afterPacking = new ChecklistDataWrapper(
                'afterPacking',
            setIcon(checklist.afterPackingDone__c,checklist.afterPackingNo__c),
            '5. Before closing the doors',
            CheckListItemsWrapper.returnAfterPackingData());
            
            ChecklistDataWrapper closingContainer = new ChecklistDataWrapper(
                'closingContainer',
            setIcon(checklist.closingContainerDone__c, checklist.closingContainerNo__c),
            '6. Closing the container',
            CheckListItemsWrapper.returnClosingContainerData());
            
            ChecklistDataWrapper dispatchingContainer = new ChecklistDataWrapper(
                'dispatchingContainer',
            setIcon(checklist.dispatchingContainerDone__c, checklist.dispatchingContainerNo__c),
            '7. Dispatching the container',
            CheckListItemsWrapper.returnDispatchingContainerData());

            data.addAll(new List<ChecklistDataWrapper>{
                packingArea,
                containerCondition,
                packingContainer,
                dangerousGoods,
                afterPacking,
                closingContainer,
                dispatchingContainer
            });

            resp = new Response(data);
        } catch (Exception e) {
            resp = new Response(e);
        }
        return resp;
    }

    public static String setIcon(Boolean stageDone, Boolean stageNo){
        if (stageNo) {
            return 'utility:warning';
        } else if (stageDone) {
            return 'utility:success';
        } else {
            return 'utility:threedots';
        }
    }
}