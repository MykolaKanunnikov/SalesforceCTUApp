import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation'
import { openReference, radioChange, options, checklistSetup } from 'c/radioGroupButtonAndHelp';
import { packingContainer } from 'c/questions';

export default class PackingContainer13to19 extends NavigationMixin(LightningElement) {
    @api recordId;

    currentChecklistId;

    packingContainer = packingContainer;

    values = '';

    // in the following code '.call' is needed to explicitly tell the  
    // imported utility function to use 'this' from the given component

    // set values and currentChecklistId fields
    connectedCallback() {
        const fields = 'ctuapptest__packingContainer13__c, ctuapptest__packingContainer14__c, ctuapptest__packingContainer15__c, ctuapptest__packingContainer16__c, ctuapptest__packingContainer17__c, ctuapptest__packingContainer18__c, ctuapptest__packingContainer19__c';
        checklistSetup.call(this, fields);
    }

    // define radio group settings 
    options = options();

    // display a relevant reference file.
    handleClick(event) {
        openReference.call(this, event);
    }

    // save values from a radio button to the database
    handleChange(event) {
        radioChange.call(this, event);
    }

}