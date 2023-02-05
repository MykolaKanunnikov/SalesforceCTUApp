/**
 * @description Plain old Apex class
 * @author Mykola Kanunnikov (Nick Eve)
 */ 
public with sharing class IconMapper {
    
    @AuraEnabled
    public String packingArea { get; set; }

    @AuraEnabled
    public String containerCondition { get; set; }
    
    @AuraEnabled
    public String packingContainer { get; set; }
    
    @AuraEnabled
    public String dangerousGoods { get; set; }
    
    @AuraEnabled
    public String afterPacking { get; set; }
    
    @AuraEnabled
    public String closingContainer { get; set; }
    
    @AuraEnabled
    public String dispatchingContainer { get; set; }

    /**
     * @description It's the only IconMapper constructor. 
     * Its' object is needed to show relevant status icon in the Tabset LWC 
     * @param  pc relevant Packing_checklist__c object
     */
    public IconMapper(Packing_checklist__c pc) {
        this.packingArea = IconMapper.setIcon(pc.packingAreaDone__c, pc.packingAreaNo__c);
        this.containerCondition = IconMapper.setIcon(pc.containerConditionDone__c, pc.containerConditionNo__c);
        this.packingContainer = IconMapper.setIcon(pc.packingContainerDone__c, pc.packingContainerNo__c);
        this.dangerousGoods = IconMapper.setIcon(pc.dangerousGoodsDone__c, pc.dangerousGoodsNo__c);
        this.afterPacking = IconMapper.setIcon(pc.afterPackingDone__c, pc.afterPackingNo__c);
        this.closingContainer = IconMapper.setIcon(pc.closingContainerDone__c, pc.closingContainerNo__c);
        this.dispatchingContainer = IconMapper.setIcon(pc.dispatchingContainerDone__c, pc.dispatchingContainerNo__c);
    }

    /**
     * @description setIcon helps to populate IconMapper object fields
     * @param  stageDone formula filed value
     * @param  stageNo   formula filed value
     * @return           String reflecting proper icon name
     */
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