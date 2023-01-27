public with sharing class IconMapper {
    
    String packingArea;
    String containerCondition;
    String packingContainer;
    String dangerousGoods;
    String afterPacking;
    String closingContainer;
    String dispatchingContainer;

    public IconMapper(String packingArea, String containerCondition, 
                        String packingContainer, String dangerousGoods, 
                            String afterPacking, String closingContainer, String dispatchingContainer) {
        this.packingArea = packingArea;
        this.containerCondition = containerCondition;
        this.packingContainer = packingContainer;
        this.dangerousGoods = dangerousGoods;
        this.afterPacking = afterPacking;
        this.closingContainer = closingContainer;
        this.dispatchingContainer = dispatchingContainer;
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