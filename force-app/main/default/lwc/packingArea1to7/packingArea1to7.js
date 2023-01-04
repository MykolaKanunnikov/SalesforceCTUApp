import { LightningElement, api } from 'lwc';
import {NavigationMixin} from 'lightning/navigation'
import getFileRecordId from '@salesforce/apex/ShipmentController.getFileRecordId';
import getCurrentChecklistId from '@salesforce/apex/ShipmentController.getCurrentChecklistId';
import updateRadioValue from '@salesforce/apex/ShipmentController.updateRadioValue';
import getChecklistValues from '@salesforce/apex/ShipmentController.getChecklistValues';


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
        if(!this.currentChecklistId){
            getCurrentChecklistId({recordId: this.recordId})
                .then(result =>{
                    this.currentChecklistId = result;
                    
                    // 2
                    getChecklistValues({currentChecklistId: result, fields: fields})
                    .then(values =>{
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
    get options() {
        return [
            { label: 'YES', value: 'YES' },
            { label: 'NO', value: 'NO' },
            { label: 'N/A', value: 'N/A' },
        ];
    }

    // display a relevant reference file
    handleClick(event){
        let itemId = event.target.dataset.id;
        let itemTitle = `${itemId}.pdf`;
        getFileRecordId({title: itemTitle})
            .then(properPdfId => {                
                try{
                this[NavigationMixin.Navigate]({ 
                    type: "standard__namedPage",
                    attributes: {
                        pageName: 'filePreview' 
                    },
                    state:{
                        selectedRecordId: properPdfId
                    }
                });
                }catch(error){
                    console.error(error);
                }  
            });
    }

    // save values from a radio button to the database
    handleChange(event){
        let value = event.target.value;
        let valueId = event.target.dataset.id;
        if(this.currentChecklistId){
            updateRadioValue({currentChecklistId: this.currentChecklistId, valueId: valueId, value: value});
        }
    }

}