import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getFileRecordId from '@salesforce/apex/ShipmentController.getFileRecordId';
import updateRadioValue from '@salesforce/apex/ShipmentController.updateRadioValue';
import getCurrentChecklistId from '@salesforce/apex/ShipmentController.getCurrentChecklistId';
import getChecklistValues from '@salesforce/apex/ShipmentController.getChecklistValues';

// define radio group 
const options = () => {
    return [
        { label: 'YES', value: 'YES' },
        { label: 'NO', value: 'NO' },
        { label: 'N/A', value: 'N/A' }
    ];
};

// 1. define apropriate checklist
// 2. retrieve already inserted values
function checklistSetup(fields) {
    getCurrentChecklistId({ recordId: this.recordId })
        .then(resp => {
            if (resp.isSuccess) {
                this.currentChecklistId = resp.responseObj;
            } else {
                const idError = new ShowToastEvent({
                    title: 'Checklist Id error',
                    variant: 'error',
                    message: resp.responseObj
                });
                this.dispatchEvent(idError);
            }
            // 2
            getChecklistValues({ currentChecklistId: resp.responseObj, fields: fields })
                .then(response => {
                    if (response.isSuccess) {
                        this.values = response.responseObj;
                    } else {
                        const valuesError = new ShowToastEvent({
                            title: 'Checklist values error',
                            variant: 'error',
                            message: response.responseObj
                        });
                        this.dispatchEvent(valuesError);
                    }
                })
                .catch(errorOnValues => {
                    const onValues = new ShowToastEvent({
                        title: 'Checklist setup error',
                        variant: 'error',
                        message: "Error: " + errorOnValues.body.message
                    });
                    this.dispatchEvent(onValues);
                })

        })
        .catch(errorOnId => {
            const onId = new ShowToastEvent({
                title: 'Checklist setup error',
                variant: 'error',
                message: "Error: " + errorOnId.body.message
            });
            this.dispatchEvent(onId);
        })
}



// display a relevant reference file    
function openReference(event) {
    let itemId = event.target.dataset.id;
    let itemTitle = `${itemId}.pdf`;
    getFileRecordId({ title: itemTitle })
        .then(resp => {
            if (resp.isSuccess) {
                this[NavigationMixin.Navigate]({
                    type: "standard__namedPage",
                    attributes: {
                        pageName: 'filePreview'
                    },
                    state: {
                        selectedRecordId: resp.responseObj
                    }
                });
            } else {
                const errorEvent = new ShowToastEvent({
                    title: 'File error',
                    variant: 'error',
                    message: resp.responseObj
                });
                this.dispatchEvent(errorEvent);
            }
        })
        .catch(error => {
            const errorEvent = new ShowToastEvent({
                title: 'File error',
                variant: 'error',
                message: "Error: " + error.body.message
            });
            this.dispatchEvent(errorEvent);
        })
}

// save values from a radio button to the database
function radioChange(event) {
    let value = event.target.value;
    let valueId = event.target.dataset.id;
    if (this.currentChecklistId) {
        updateRadioValue({ currentChecklistId: this.currentChecklistId, valueId: valueId, value: value })
            .then(resp => {
                if (!resp.isSuccess) {
                    const errorEvent = new ShowToastEvent({
                        title: 'Save error',
                        variant: 'error',
                        message: resp.responseObj
                    });
                    this.dispatchEvent(errorEvent);
                }
            })
            .catch(error => {
                const noResponseEvent = new ShowToastEvent({
                    title: 'Save error',
                    variant: 'error',
                    message: 'No response / saving: ' + error.body.message
                });
                this.dispatchEvent(noResponseEvent);
            })
    }
}

export { openReference, radioChange, options, checklistSetup };