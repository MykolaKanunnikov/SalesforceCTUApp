public with sharing class CheckListItemsWrapper {
    @AuraEnabled
    public String name { get; set; }
    
    @AuraEnabled
    public String fieldApiName { get; set; }
    
    @AuraEnabled
    public String referenceId { get; set; }
    
    public CheckListItemsWrapper(String name, String fieldApi, String referenceId) {
        this.name = name;
        this.fieldApiName = fieldApi;
        this.referenceId = referenceId;
    }
    
    public static List<CheckListItemsWrapper> returnPackingAreaData() {
        List<CheckListItemsWrapper> packingAreaData = new List<CheckListItemsWrapper>();
        
        CheckListItemsWrapper packingArea1 = new CheckListItemsWrapper('1. Is the type of container appropriate for the cargo to be carried?', 'packingArea1__c','1');
        CheckListItemsWrapper packingArea2 = new CheckListItemsWrapper('2. Is the container positioned so that it can be accessed safely?', 'packingArea2__c','2');
        CheckListItemsWrapper packingArea3 = new CheckListItemsWrapper('3. Have steps been taken to avoid contamination of the packing area by pests?', 'packingArea3__c','3');
        CheckListItemsWrapper packingArea4 = new CheckListItemsWrapper('4. Has a packing plan been prepared showing the arrangements of goods in the container?', 'packingArea4__c','4');
        CheckListItemsWrapper packingArea5 = new CheckListItemsWrapper('5. Are the maximum permitted payload limits of the container sufficient for the intended load?', 'packingArea5__c','5');
        CheckListItemsWrapper packingArea6 = new CheckListItemsWrapper('6. Do all timber pallets, dunnage or other wood packing material meet ISPM‑15 standards and show the required markings?', 'packingArea6__c','6');
        CheckListItemsWrapper packingArea7 = new CheckListItemsWrapper('7. Have staff assigned to pack the container been trained to understand the practices of safe packing and securing and avoidance of pest contamination?', 'packingArea7__c','7');
        
        packingAreaData.add(packingArea1);
        packingAreaData.add(packingArea2);
        packingAreaData.add(packingArea3);
        packingAreaData.add(packingArea4);
        packingAreaData.add(packingArea5);
        packingAreaData.add(packingArea6);
        packingAreaData.add(packingArea7);
        
        return packingAreaData;
    }
    
    public static List<CheckListItemsWrapper> returnContainerConditionData() {
        List<CheckListItemsWrapper> containerConditionData = new List<CheckListItemsWrapper>();
        containerConditionData.add(new CheckListItemsWrapper('8. Is the container exterior free from soil or other visible infestation by pests?', 'containerCondition8__c', '8'));
        containerConditionData.add(new CheckListItemsWrapper('9. Is the container exterior in good condition, and not significantly distorted, cracked or bent?', 'containerCondition9__c', '9'));
        containerConditionData.add(new CheckListItemsWrapper('10. Does the container have a valid CSC Approval Plate?', 'containerCondition10__c', '10'));
        containerConditionData.add(new CheckListItemsWrapper('11. Is the container interior free from signs of damage, signs of water ingress, rust, residues, stains or debris?', 'containerCondition11__c', '11'));
        containerConditionData.add(new CheckListItemsWrapper('12. Is the container interior free from soil or other visible infestation by pests?', 'containerCondition12__c', '12'));
        return containerConditionData;
    }
    
    public static List<CheckListItemsWrapper> returnPackingContainerData() {
        List<CheckListItemsWrapper> packingContainerData = new List<CheckListItemsWrapper>();
        packingContainerData.add(new CheckListItemsWrapper('13. Is the cargo to be packed free from soil or other visible infestation by pests?', 'packingContainer13__c', '13and27'));
        packingContainerData.add(new CheckListItemsWrapper('14. Has the heavier cargo been packed at the bottom of the container with any lighter weight cargo on top?', 'packingContainer14__c', '14'));
        packingContainerData.add(new CheckListItemsWrapper('15. Is the cargo distributed evenly across the floor of the container to spread the load?', 'packingContainer15__c', '15'));
        packingContainerData.add(new CheckListItemsWrapper('16. Is the centre of gravity approximately in the centre of the container?', 'packingContainer16__c', '16'));
        packingContainerData.add(new CheckListItemsWrapper('17. Has the cargo been packed in approximately even layers?', 'packingContainer17__c', '17'));
        packingContainerData.add(new CheckListItemsWrapper('18. Have packages with package orientation labels been stowed the correct way up?', 'packingContainer18__c', '18'));
        packingContainerData.add(new CheckListItemsWrapper('19. Has locking, blocking or lashing been used to prevent the cargo from sliding and tipping in the container in any direction?', 'packingContainer19__c', '19'));
        return packingContainerData;
    }
    
    public static List<CheckListItemsWrapper> returnDangerousGoodsData() {
        List<CheckListItemsWrapper> dangerousGoodsData = new List<CheckListItemsWrapper>();
        dangerousGoodsData.add(new CheckListItemsWrapper('20. Are all Dangerous Goods packages marked and labelled in accordance with the IMDG Code?', 'dangerousGoods20__c', '20and21'));
        dangerousGoodsData.add(new CheckListItemsWrapper('21. Are all Dangerous Goods packages undamaged and in sound condition?', 'dangerousGoods21__c', '20and21'));
        dangerousGoodsData.add(new CheckListItemsWrapper('22. Where Dangerous Goods comprise only part of the cargo, are they packed as close to the doors as possible?', 'dangerousGoods22__c', '22'));
        dangerousGoodsData.add(new CheckListItemsWrapper('23. Has the container been placarded in accordance with the IMDG Code?', 'dangerousGoods23__c', '23'));
        return dangerousGoodsData;
    }
    
    public static List<CheckListItemsWrapper> returnAfterPackingData() {
        List<CheckListItemsWrapper> afterPackingData = new List<CheckListItemsWrapper>();
        afterPackingData.add(new CheckListItemsWrapper('24. Have all void spaces (gaps) within the cargo stow and/or between the cargo and container structure been filled?', 'afterPacking24__c', '24and25'));
        afterPackingData.add(new CheckListItemsWrapper('25. Is the cargo blocking and bracing distributed over a sufficiently large area of the container (e.g. by use of spreader beams)?', 'afterPacking25__c', '24and25'));
        afterPackingData.add(new CheckListItemsWrapper('26. Are lashings secured to the container so as not to over‑stress its structure?', 'afterPacking26__c', '26'));
        afterPackingData.add(new CheckListItemsWrapper('27. Are both the interior and the exterior of the container, and its cargo, free of soil, or other visible infestation by pests?', 'afterPacking27__c', '13and27'));
        return afterPackingData;
    }
    
    public static List<CheckListItemsWrapper> returnClosingContainerData() {
        List<CheckListItemsWrapper> closingContainerData = new List<CheckListItemsWrapper>();
        closingContainerData.add(new CheckListItemsWrapper('28. Have the doors of the container been securely closed and latched?', 'closingContainer28__c', '28to31'));
        closingContainerData.add(new CheckListItemsWrapper('29. Has a seal been affixed to the container and its number recorded?', 'closingContainer29__c', '28to31'));
        return closingContainerData;
    }
    
    public static List<CheckListItemsWrapper> returnDispatchingContainerData() {
        List<CheckListItemsWrapper> dispatchingContainerData = new List<CheckListItemsWrapper>();
        dispatchingContainerData.add(new CheckListItemsWrapper('30. For the packed container, has the Verified Gross Mass been communicated to the carrier as early as required by the carrier?', 'dispatchingContainer30__c', '28to31'));
        dispatchingContainerData.add(new CheckListItemsWrapper('31. For the packed container, has the identity of the container and the seal number been communicated to the carrier as early as required by the carrier?', 'dispatchingContainer31__c', '28to31'));
        dispatchingContainerData.add(new CheckListItemsWrapper('32. For the cargo, has an accurate description (including classification) of the cargo itself and the packaging been communicated to the carrier, as early as required by the carrier?', 'dispatchingContainer32__c', '32'));
        dispatchingContainerData.add(new CheckListItemsWrapper('33. For the cargo, have the number and types of packages and the cargo mass (for Customs purposes) been communicated to the carrier, as early as required by the carrier?', 'dispatchingContainer33__c', '33'));
        dispatchingContainerData.add(new CheckListItemsWrapper('34. For Dangerous Goods, has a Shipper’s Declaration and, where required, a Packing Certificate declaration been made and communicated to the carrier as early as required by the carrier?', 'dispatchingContainer34__c', '34'));
        return dispatchingContainerData;
    }
}