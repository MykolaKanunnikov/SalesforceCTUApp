/**
 * @author Mykola Kanunnikov (Nick Eve);
 */

import { LightningElement, api } from "lwc";
import formFactor from "@salesforce/client/formFactor";
import getIconMapObject from "@salesforce/apex/ShipmentController.getIconMapObject";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getChecklistData from "@salesforce/apex/ChecklistDataWrapper.getChecklistData";


const inspectionChecklist = [
    {
        section: "packingArea",
        label: "1. The packing area",
        items: [
            {
                name: "1. Is the type of container appropriate for the cargo to be carried?",
                fieldApiName: "packingArea1__c",
                referenceId: "1"
            },
            {
                name: "2. Is the container positioned so that it can be accessed safely?",
                fieldApiName: "packingArea2__c",
                referenceId: "2"
            },
            {
                name: "3. Have steps been taken to avoid contamination of the packing area by pests?",
                fieldApiName: "packingArea3__c",
                referenceId: "3"
            },
            {
                name: "4. Has a packing plan been prepared showing the arrangements of goods in the container?",
                fieldApiName: "packingArea4__c",
                referenceId: "4"
            },
            {
                name: "5. Are the maximum permitted payload limits of the container sufficient for the intended load?",
                fieldApiName: "packingArea5__c",
                referenceId: "5"
            },
            {
                name: "6. Do all timber pallets, dunnage or other wood packing material meet ISPM‑15 standards and show the required markings?",
                fieldApiName: "packingArea6__c",
                referenceId: "6"
            },
            {
                name: "7. Have staff assigned to pack the container been trained to understand the practices of safe packing and securing and avoidance of pest contamination?",
                fieldApiName: "packingArea7__c",
                referenceId: "7"
            }
        ]
    },
    {
        section: "containerCondition",
        label: "2. Container condition",
        items: [
            {
                name: "8. Is the container exterior free from soil or other visible infestation by pests?",
                fieldApiName: "containerCondition8__c",
                referenceId: "8"
            },
            {
                name: "9. Is the container exterior in good condition, and not significantly distorted, cracked or bent?",
                fieldApiName: "containerCondition9__c",
                referenceId: "9"
            },
            {
                name: "10. Does the container have a valid CSC Approval Plate?",
                fieldApiName: "containerCondition10__c",
                referenceId: "10"
            },
            {
                name: "11. Is the container interior free from signs of damage, signs of water ingress, rust, residues, stains or debris?",
                fieldApiName: "containerCondition11__c",
                referenceId: "11"
            },
            {
                name: "12. Is the container interior free from soil or other visible infestation by pests?",
                fieldApiName: "containerCondition12__c",
                referenceId: "12"
            }
        ]
    },
    {
        section: "packingContainer",
        label: "3. Packing the container",
        items: [
            {
                name: "13. Is the cargo to be packed free from soil or other visible infestation by pests?",
                fieldApiName: "packingContainer13__c",
                referenceId: "13and27"
            },
            {
                name: "14. Has the heavier cargo been packed at the bottom of the container with any lighter weight cargo on top?",
                fieldApiName: "packingContainer14__c",
                referenceId: "14"
            },
            {
                name: "15. Is the cargo distributed evenly across the floor of the container to spread the load?",
                fieldApiName: "packingContainer15__c",
                referenceId: "15"
            },
            {
                name: "16. Is the centre of gravity approximately in the centre of the container?",
                fieldApiName: "packingContainer16__c",
                referenceId: "16"
            },
            {
                name: "17. Has the cargo been packed in approximately even layers?",
                fieldApiName: "packingContainer17__c",
                referenceId: "17"
            },
            {
                name: "18. Have packages with package orientation labels been stowed the correct way up?",
                fieldApiName: "packingContainer18__c",
                referenceId: "18"
            },
            {
                name: "19. Has locking, blocking or lashing been used to prevent the cargo from sliding and tipping in the container in any direction?",
                fieldApiName: "packingContainer19__c",
                referenceId: "19"
            }
        ]
    },
    {
        section: "dangerousGoods",
        label: "4. Dangerous goods",
        items: [
            {
                name: "20. Are all Dangerous Goods packages marked and labelled in accordance with the IMDG Code?",
                fieldApiName: "dangerousGoods20__c",
                referenceId: "20and21"
            },
            {
                name: "21. Are all Dangerous Goods packages undamaged and in sound condition?",
                fieldApiName: "dangerousGoods21__c",
                referenceId: "20and21"
            },
            {
                name: "22. Where Dangerous Goods comprise only part of the cargo, are they packed as close to the doors as possible?",
                fieldApiName: "dangerousGoods22__c",
                referenceId: "22"
            },
            {
                name: "23. Has the container been placarded in accordance with the IMDG Code?",
                fieldApiName: "dangerousGoods23__c",
                referenceId: "23"
            }
        ]
    },
    {
        section: "afterPacking",
        label: "5. Before closing the doors",
        items: [
            {
                name: "24. Have all void spaces (gaps) within the cargo stow and/or between the cargo and container structure been filled?",
                fieldApiName: "afterPacking24__c",
                referenceId: "24and25"
            },
            {
                name: "25. Is the cargo blocking and bracing distributed over a sufficiently large area of the container (e.g. by use of spreader beams)?",
                fieldApiName: "afterPacking25__c",
                referenceId: "24and25"
            },
            {
                name: "26. Are lashings secured to the container so as not to over‑stress its structure?",
                fieldApiName: "afterPacking26__c",
                referenceId: "26"
            },
            {
                name: "27. Are both the interior and the exterior of the container, and its cargo, free of soil, or other visible infestation by pests?",
                fieldApiName: "afterPacking27__c",
                referenceId: "13and27"
            }
        ]
    },
    {
        section: "closingContainer",
        label: "6. Closing the container",
        items: [
            {
                name: "28. Have the doors of the container been securely closed and latched?",
                fieldApiName: "closingContainer28__c",
                referenceId: "28to31"
            },
            {
                name: "29. Has a seal been affixed to the container and its number recorded?",
                fieldApiName: "closingContainer29__c",
                referenceId: "28to31"
            }
        ]
    },
    {
        section: "dispatchingContainer",
        label: "7. Dispatching the container",
        items: [
            {
                name: "30. For the packed container, has the Verified Gross Mass been communicated to the carrier as early as required by the carrier?",
                fieldApiName: "dispatchingContainer30__c",
                referenceId: "28to31"
            },
            {
                name: "31. For the packed container, has the identity of the container and the seal number been communicated to the carrier as early as required by the carrier?",
                fieldApiName: "dispatchingContainer31__c",
                referenceId: "28to31"
            },
            {
                name: "32. For the cargo, has an accurate description (including classification) of the cargo itself and the packaging been communicated to the carrier, as early as required by the carrier?",
                fieldApiName: "dispatchingContainer32__c",
                referenceId: "32"
            },
            {
                name: "33. For the cargo, have the number and types of packages and the cargo mass (for Customs purposes) been communicated to the carrier, as early as required by the carrier?",
                fieldApiName: "dispatchingContainer33__c",
                referenceId: "33"
            },
            {
                name: "34. For Dangerous Goods, has a Shipper’s Declaration and, where required, a Packing Certificate declaration been made and communicated to the carrier as early as required by the carrier?",
                fieldApiName: "dispatchingContainer34__c",
                referenceId: "34"
            }
        ]
    }
];

export default class ChecklistTabset extends LightningElement {
    @api recordId;
    testData;
    checklist;

    connectedCallback() {
        this.getData();
    }

    getIcons() {
        return getIconMapObject({ recordId: this.recordId })
            .then((resp) => {
                if (resp.isSuccess) {
                    return resp.responseObj;
                }
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Status icons JS error",
                        variant: "error"
                    })
                );
            })
            .catch((error) => {
                console.error(error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Status icons Apex error",
                        variant: "error"
                    })
                );
            });
    }

    getData(){
        getChecklistData({recordId: this.recordId}).then(resp=>
            this.checklist = resp.responseObj
        )
    }

     buildChecklistWithIcons() {
         this.getIcons().then(
            (iconMap) =>
                this.checklist = inspectionChecklist.map((section) => ({
                    ...section,
                    icon: iconMap[section.section] || "utility:question"
                }))
        );
    }

    handleIconSetup(event) {
        const data = this.checklist.map((item) => {
            if (item.section === event.detail.section) {
                item.icon = event.detail.icon;
            }
            return item;
        });
        this.checklist = data;
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
