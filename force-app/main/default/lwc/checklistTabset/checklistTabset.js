/**
 * @author Mykola Kanunnikov (Nick Eve);
 */

import { LightningElement, api } from "lwc";
import formFactor from "@salesforce/client/formFactor";
import getIconMapObject from "@salesforce/apex/ShipmentController.getIconMapObject";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import {
    packingArea,
    dangerousGoods,
    closingContainer,
    containerCondition,
    dispatchingContainer,
    packingContainer,
    afterPacking
    
} from "c/questions";

export default class ChecklistTabset extends LightningElement {
    @api recordId;
    packingArea = packingArea;
    dangerousGoods = dangerousGoods;
    closingContainer = closingContainer;
    containerCondition = containerCondition;
    dispatchingContainer = dispatchingContainer;
    packingContainer = packingContainer;
    afterPacking = afterPacking;
    iconName = "";

    // display status icons depending on answers in the checklist
    renderedCallback() {
        if (this.iconName === "") {
            getIconMapObject({ recordId: this.recordId })
                .then((resp) => {
                    if (resp.isSuccess) {
                        this.iconName = resp.responseObj;
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
        }
    }

    // vertical variant isn't a good fit for small-sized phones and tablets
    get tabsetVariant() {
        if (formFactor === "Large") {
            return "vertical";
        } else {
            return "standard";
        }
    }

    // unlock renderedCallback once tab is switched
    letUpdateIcons() {
        this.iconName = "";
    }
}
