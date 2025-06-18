import { api, LightningElement } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getFileRecordId from "@salesforce/apex/ShipmentController.getFileRecordId";

export default class ReferenceButton extends NavigationMixin(LightningElement) {
    @api reference;

    handleClick() {
        // get asset id from the dataset and concatenate with string
        getFileRecordId({ title: `asset_${this.reference}pdf` })
            .then((resp) => {
                if (resp.isSuccess) {
                    this[NavigationMixin.Navigate]({
                        type: "standard__namedPage",
                        attributes: {
                            pageName: "filePreview"
                        },
                        state: {
                            selectedRecordId: resp.responseObj
                        }
                    });
                } else {
                    const errorEvent = new ShowToastEvent({
                        title: "File error",
                        variant: "error",
                        message: resp.responseObj
                    });
                    this.dispatchEvent(errorEvent);
                }
            })
            .catch((error) => {
                const errorEvent = new ShowToastEvent({
                    title: "File error",
                    variant: "error",
                    message: "Error: " + error.body.message
                });
                this.dispatchEvent(errorEvent);
            });
    }
}
