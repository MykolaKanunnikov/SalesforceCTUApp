import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation'
import getCurrentChecklistId from '@salesforce/apex/ShipmentController.getCurrentChecklistId';
import getChecklistValues from '@salesforce/apex/ShipmentController.getChecklistValues';
import { openReference, radioChange, options } from 'c/radioGroupButtonAndHelp';

export default class PackingArea1to7 extends NavigationMixin(LightningElement) {

    @api recordId;

    currentChecklistId;

    value1 = '';
    value2 = '';
    value3 = '';
    value4 = '';
    value5 = '';
    value6 = '';
    value7 = '';

    // 1. define apropriate checklist when a component is inserted to the DOM
    // 2. retrieve already inserted values
    connectedCallback() {
        // 1
        const fields = 'packingArea1__c, packingArea2__c, packingArea3__c, packingArea4__c, packingArea5__c, packingArea6__c, packingArea7__c';
        if (!this.currentChecklistId) {
            getCurrentChecklistId({ recordId: this.recordId })
                .then(result => {
                    this.currentChecklistId = result;

                    // 2
                    getChecklistValues({ currentChecklistId: result, fields: fields })
                        .then(values => {
                            this.value1 = values.packingArea1__c;
                            this.value2 = values.packingArea2__c;
                            this.value3 = values.packingArea3__c;
                            this.value4 = values.packingArea4__c;
                            this.value5 = values.packingArea5__c;
                            this.value6 = values.packingArea6__c;
                            this.value7 = values.packingArea7__c;
                        })
                });
        }
    }

    // define radio group settings 
    options = options();

    // in the following code '.call' is needed to explicitly tell the  
    // imported utility function to use 'this' from the given component

    // display a relevant reference file.
    handleClick(event) {
        openReference.call(this, event);
    }

    // save values from a radio button to the database
    handleChange(event) {
        radioChange.call(this, event);
    }

}