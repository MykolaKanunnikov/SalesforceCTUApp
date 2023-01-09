import { LightningElement, api } from 'lwc';
import formFactor from '@salesforce/client/formFactor'

export default class ChecklistTabset extends LightningElement {

    @api recordId;

    // vertical variant isn't a good fit for small-sized phones and tablets
    get tabsetVariant() {
        if (formFactor === 'Large') {
            return 'vertical';
        } else {
            return 'standard';
        }
    }

}