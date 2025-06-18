/**
 * @author Mykola Kanunnikov (Nick Eve);
 */

import { LightningElement, api } from "lwc";
import formFactor from "@salesforce/client/formFactor";
import getIconMapObject from "@salesforce/apex/ShipmentController.getIconMapObject";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

const inspectionChecklist = [   
    {
        section: "packingArea",
        label: "1. The packing area",
        items: [
            {
                name: "1. Is the type of container appropriate for the cargo to be carried?",
                fieldId: "packingArea1__c",
                picklistValues: "values.ctuapptest__packingArea1__c",
                buttonId: 1
            },
            {
                name: "2. Is the container positioned so that it can be accessed safely?",
                fieldId: "packingArea2__c",
                picklistValues: "values.ctuatttest__packingArea2__c",
                buttonId: 2
            },
            {
                name: "3. Have steps been taken to avoid contamination of the packing area by pests?",
                fieldId: "packingArea3__c",
                picklistValues: "values.ctuapptest__packingArea3__c",
                buttonId: 3
            },
            {
                name: "4. Has a packing plan been prepared showing the arrangements of goods in the container?",
                fieldId: "packingArea4__c",
                picklistValues: "values.ctuapptest__packingArea4__c",
                buttonId: 4
            },
            {
                name: "5. Are the maximum permitted payload limits of the container sufficient for the intended load?",
                fieldId: "packingArea5__c",
                picklistValues: "values.ctuapptest__packingArea5__c",
                buttonId: 5
            },
            {
                name: "6. Do all timber pallets, dunnage or other wood packing material meet ISPM‑15 standards and show the required markings?",
                fieldId: "packingArea6__c",
                picklistValues: "values.ctuapptest__packingArea6__c",
                buttonId: 6
            },
            {
                name: "7. Have staff assigned to pack the container been trained to understand the practices of safe packing and securing and avoidance of pest contamination?",
                fieldId: "packingArea7__c",
                picklistValues: "values.ctuapptest__packingArea7__c",
                buttonId: 7
            }
        ]
    },
    {
        section: "containerCondition",
        label: "2. Container condition",
        items: [
            {
                name: "8. Is the container exterior free from soil or other visible infestation by pests?",
                fieldId: "containerCondition8__c",
                picklistValues: "values.ctuapptest__containerCondition8__c",
                buttonId: 8
            },
            {
                name: "9. Is the container exterior in good condition, and not significantly distorted, cracked or bent?",
                fieldId: "containerCondition9__c",
                picklistValues: "values.ctuapptest__containerCondition9__c",
                buttonId: 9
            },
            {
                name: "10. Does the container have a valid CSC Approval Plate?",
                fieldId: "containerCondition10__c",
                picklistValues: "values.ctuapptest__containerCondition10__c",
                buttonId: 10
            },
            {
                name: "11. Is the container interior free from signs of damage, signs of water ingress, rust, residues, stains or debris?",
                fieldId: "containerCondition11__c",
                picklistValues: "values.ctuapptest__containerCondition11__c",
                buttonId: 11
            },
            {
                name: "12. Is the container interior free from soil or other visible infestation by pests?",
                fieldId: "containerCondition12__c",
                picklistValues: "values.ctuapptest__containerCondition12__c",
                buttonId: 12
            }
        ]
    },
    {
        section: "packingContainer",
        label: "3. Packing the container",
        items: [
            {
                name: "13. Is the cargo to be packed free from soil or other visible infestation by pests?",
                fieldId: "packingContainer13__c",
                picklistValues: "values.ctuapptest__packingContainer13__c",
                buttonId: "13and27"
            },
            {
                name: "14. Has the heavier cargo been packed at the bottom of the container with any lighter weight cargo on top?",
                fieldId: "packingContainer14__c",
                picklistValues: "values.ctuapptest__packingContainer14__c",
                buttonId: 14
            },
            {
                name: "15. Is the cargo distributed evenly across the floor of the container to spread the load?",
                fieldId: "packingContainer15__c",
                picklistValues: "values.ctuapptest__packingContainer15__c",
                buttonId: 15
            },
            {
                name: "16. Is the centre of gravity approximately in the centre of the container?",
                fieldId: "packingContainer16__c",
                picklistValues: "values.ctuapptest__packingContainer16__c",
                buttonId: 16
            },
            {
                name: "17. Has the cargo been packed in approximately even layers?",
                fieldId: "packingContainer17__c",
                picklistValues: "values.ctuapptest__packingContainer17__c",
                buttonId: 17
            },
            {
                name: "18. Have packages with package orientation labels been stowed the correct way up?",
                fieldId: "packingContainer18__c",
                picklistValues: "values.ctuapptest__packingContainer18__c",
                buttonId: 18
            },
            {
                name: "19. Has locking, blocking or lashing been used to prevent the cargo from sliding and tipping in the container in any direction?",
                fieldId: "packingContainer19__c",
                picklistValues: "values.ctuapptest__packingContainer19__c",
                buttonId: 19
            }
        ]
    },
    {
        section: "dangerousGoods",
        label: "4. Dangerous goods",
        items: [
            {
                name: "20. Are all Dangerous Goods packages marked and labelled in accordance with the IMDG Code?",
                fieldId: "dangerousGoods20__c",
                picklistValues: "values.ctuapptest__dangerousGoods20__c",
                buttonId: "20and21"
            },
            {
                name: "21. Are all Dangerous Goods packages undamaged and in sound condition?",
                fieldId: "dangerousGoods21__c",
                picklistValues: "values.ctuapptest__dangerousGoods21__c",
                buttonId: "20and21"
            },
            {
                name: "22. Where Dangerous Goods comprise only part of the cargo, are they packed as close to the doors as possible?",
                fieldId: "dangerousGoods22__c",
                picklistValues: "values.ctuapptest__dangerousGoods22__c",
                buttonId: 22
            },
            {
                name: "23. Has the container been placarded in accordance with the IMDG Code?",
                fieldId: "dangerousGoods23__c",
                picklistValues: "values.ctuapptest__dangerousGoods23__c",
                buttonId: 23
            }
        ]
    },
    {
        section: "afterPacking",
        label: "5. Before closing the doors",
        items: [
            {
                name: "24. Have all void spaces (gaps) within the cargo stow and/or between the cargo and container structure been filled?",
                fieldId: "afterPacking24__c",
                picklistValues: "values.ctuapptest__afterPacking24__c",
                buttonId: "24and25"
            },
            {
                name: "25. Is the cargo blocking and bracing distributed over a sufficiently large area of the container (e.g. by use of spreader beams)?",
                fieldId: "afterPacking25__c",
                picklistValues: "values.ctuapptest__afterPacking25__c",
                buttonId: "24and25"
            },
            {
                name: "26. Are lashings secured to the container so as not to over‑stress its structure?",
                fieldId: "afterPacking26__c",
                picklistValues: "values.ctuapptest__afterPacking26__c",
                buttonId: 26
            },
            {
                name: "27. Are both the interior and the exterior of the container, and its cargo, free of soil, or other visible infestation by pests?",
                fieldId: "afterPacking27__c",
                picklistValues: "values.ctuapptest__afterPacking27__c",
                buttonId: "13and27"
            }
        ]
    },
    {
        section: "closingContainer",
        label: "6. Closing the container",
        items: [
            {
                name: "28. Have the doors of the container been securely closed and latched?",
                fieldId: "closingContainer28__c",
                picklistValues: "values.ctuapptest__closingContainer28__c",
                buttonId: "28to31"
            },
            {
                name: "29. Has a seal been affixed to the container and its number recorded?",
                fieldId: "closingContainer29__c",
                picklistValues: "values.ctuapptest__closingContainer29__c",
                buttonId: "28to31"
            }
        ]
    },
    {
        section: "dispatchingContainer",
        label: "7. Dispatching the container",
        items: [
            {
                name: "30. For the packed container, has the Verified Gross Mass been communicated to the carrier as early as required by the carrier?",
                fieldId: "dispatchingContainer30__c",
                picklistValues: "values.ctuapptest__dispatchingContainer30__c",
                buttonId: "28to31"
            },
            {
                name: "31. For the packed container, has the identity of the container and the seal number been communicated to the carrier as early as required by the carrier?",
                fieldId: "dispatchingContainer31__c",
                picklistValues: "values.ctuapptest__dispatchingContainer31__c",
                buttonId: "28to31"
            },
            {
                name: "32. For the cargo, has an accurate description (including classification) of the cargo itself and the packaging been communicated to the carrier, as early as required by the carrier?",
                fieldId: "dispatchingContainer32__c",
                picklistValues: "values.ctuapptest__dispatchingContainer32__c",
                buttonId: 32
            },
            {
                name: "33. For the cargo, have the number and types of packages and the cargo mass (for Customs purposes) been communicated to the carrier, as early as required by the carrier?",
                fieldId: "dispatchingContainer33__c",
                picklistValues: "values.ctuapptest__dispatchingContainer33__c",
                buttonId: 33
            },
            {
                name: "34. For Dangerous Goods, has a Shipper’s Declaration and, where required, a Packing Certificate declaration been made and communicated to the carrier as early as required by the carrier?",
                fieldId: "dispatchingContainer34__c",
                picklistValues: "values.ctuapptest__dispatchingContainer34__c",
                buttonId: 34
            }
        ]
    }
];

async function getIcons(recordId) {
    let allIcons = {};
    await getIconMapObject({ recordId: recordId })
        .then((resp) => {
            if (resp.isSuccess) {
                allIcons = resp.responseObj;
            } else {
                const errorEvent = new ShowToastEvent({
                    title: "Status icons JS error",
                    variant: "error",
                    message: resp.responseObj
                });
                this.dispatchEvent(errorEvent);
            }
        })
        .catch((error) => {
            const errorEvent = new ShowToastEvent({
                title: "Status icons Apex error",
                variant: "error",
                message: "Error: " + error.body.message
            });
            this.dispatchEvent(errorEvent);
        });
    return allIcons;
}

async function buildChecklistWithIcons(recordId) {
    const iconMap = await getIcons(recordId);
    return inspectionChecklist.map((section) => ({
        ...section,
        icon: iconMap[section.section] || "utility:question"
    }));
}

export default class ChecklistTabset extends LightningElement {
    @api recordId;
    checklist;

    async connectedCallback() {
        this.checklist =  await buildChecklistWithIcons(this.recordId);
    }

    async handleSave(){
        this.checklist =  await buildChecklistWithIcons(this.recordId);
    }
    // vertical variant isn't a good fit for small-sized phones and tablets
    get tabsetVariant() {
        if (formFactor === "Large") {
            return "vertical";
        } else {
            return "standard";
        }
    }
}
