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
            Packing_checklist__c checklist = [SELECT Shipment__c,afterPackingIcon__c, closingContainerIcon__c, containerConditionIcon__c, dangerousGoodsIcon__c, dispatchingContainerIcon__c, PackingAreaIcon__c, packingContainerIcon__c FROM Packing_checklist__c WHERE Shipment__c =:recordId];
            List<CheckListItemsWrapper> items = new List<CheckListItemsWrapper>();
            ChecklistDataWrapper packingArea = new ChecklistDataWrapper(
                'packingArea',
            checklist.ctuapptest__PackingAreaIcon__c,
            '1. The packing area',
            CheckListItemsWrapper.returnPackingAreaData());
            
            ChecklistDataWrapper containerCondition = new ChecklistDataWrapper(
                'containerCondition',
            checklist.ctuapptest__containerConditionIcon__c,
            '2. Container condition',
            CheckListItemsWrapper.returnContainerConditionData());
            
            ChecklistDataWrapper packingContainer = new ChecklistDataWrapper(
                'packingContainer',
            checklist.ctuapptest__packingContainerIcon__c,
            '3. Packing the container',
            CheckListItemsWrapper.returnPackingContainerData());
            
            ChecklistDataWrapper dangerousGoods = new ChecklistDataWrapper(
                'dangerousGoods',
            checklist.ctuapptest__dangerousGoodsIcon__c,
            '4. Dangerous goods',
            CheckListItemsWrapper.returnDangerousGoodsData());
            
            ChecklistDataWrapper afterPacking = new ChecklistDataWrapper(
                'afterPacking',
            Checklist.ctuapptest__afterPackingIcon__c,
            '5. Before closing the doors',
            CheckListItemsWrapper.returnAfterPackingData());
            
            ChecklistDataWrapper closingContainer = new ChecklistDataWrapper(
                'closingContainer',
            checklist.ctuapptest__closingContainerIcon__c,
            '6. Closing the container',
            CheckListItemsWrapper.returnClosingContainerData());
            
            ChecklistDataWrapper dispatchingContainer = new ChecklistDataWrapper(
                'dispatchingContainer',
            checklist.ctuapptest__dispatchingContainerIcon__c,
            '7. Dispatching the container',
            
            CheckListItemsWrapper.returnDispatchingContainerData());
            data.add(packingArea);
            data.add(containerCondition);
            data.add(packingContainer);
            data.add(dangerousGoods);
            data.add(afterPacking);
            data.add(closingContainer);
            data.add(dispatchingContainer);
            resp = new Response(data);
        } catch (Exception e) {
            resp = new Response(e);
        }
        return resp;
    }
}