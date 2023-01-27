import { LightningElement, api } from 'lwc';
import formFactor from '@salesforce/client/formFactor'
import getIconMapObject from '@salesforce/apex/ShipmentController.getIconMapObject';


export default class ChecklistTabset extends LightningElement {

    @api recordId;
    
    iconName = '';

    renderedCallback(){
        getIconMapObject({ recordId: this.recordId })
        .then(resp => {
            if (resp.isSuccess) {
                const respObject = JSON.parse(resp.responseObj);
                this.iconName = respObject;
            } else {
                console.log('Not success - ' + JSON.stringify(resp));
            }
        })

    }

    // vertical variant isn't a good fit for small-sized phones and tablets
    get tabsetVariant() {
        if (formFactor === 'Large') {
            return 'vertical';
        } else {
            return 'standard';
        }
    }

}