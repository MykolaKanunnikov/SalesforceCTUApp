import { LightningElement, api } from 'lwc';
import {NavigationMixin} from 'lightning/navigation'
import getFileRecordId from '@salesforce/apex/ShipmentController.getFileRecordId';
import getCurrentChecklistId from '@salesforce/apex/ShipmentController.getCurrentChecklistId';
import updateRadioValue from '@salesforce/apex/ShipmentController.updateRadioValue';
import getChecklistValues from '@salesforce/apex/ShipmentController.getChecklistValues';


export default class PackingArea1to7 extends NavigationMixin(LightningElement) {

    @api recordId;
    
    currentChecklistId;

    value = '';

    /*value1 = '';
    value2 = '';
    value3 = '';
    value4 = '';
    value5 = '';
    value6 = '';
    value7 = '';*/

    // 1. define apropriate checklist when a component is inserted to the DOM
    // 2. retrieve already inserted values
    connectedCallback() {
        // 1
        if(!this.currentChecklistId){
            getCurrentChecklistId({recordId: this.recordId})
                .then(result =>{
                    this.currentChecklistId = result;
                });
        }

        //2
        
    }

    renderedCallback() {
        console.log(this.template.querySelectorAll('[data-id]'));

    }

    /*get radioButtonElements() {
        return this.template.querySelectorAll('[data-id]');
    }*/

    get value(){
        return this.value;
       /* let itemId = event.target.dataset.id;
        console.log('value itemId ' + itemId);
        getChecklistValues({currentChecklistId: this.currentChecklistId})
            .then(result =>{
                try{
                console.log('value result ' + result);
                if(result) {
                    console.log('result is not null');
                    return result;
                } else {
                    return 'NO';
                }
            }catch(error){
                console.error(error);
            }

            });*/
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
        console.log(this.currentChecklistId);
        if(this.currentChecklistId){
            updateRadioValue({currentChecklistId: this.currentChecklistId, valueId: valueId, value: value});
        }
    }

}