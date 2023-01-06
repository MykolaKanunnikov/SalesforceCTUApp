import { NavigationMixin } from 'lightning/navigation'
import getFileRecordId from '@salesforce/apex/ShipmentController.getFileRecordId';
import updateRadioValue from '@salesforce/apex/ShipmentController.updateRadioValue';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// define radio group 
const options = () => {
    return [
        { label: 'YES', value: 'YES' },
        { label: 'NO', value: 'NO' },
        { label: 'N/A', value: 'N/A' }
    ];
};

// display a relevant reference file    
function openReference(event) {
    let itemId = event.target.dataset.id;
    let itemTitle = `${itemId}.pdf`;
    getFileRecordId({ title: itemTitle })
        .then(properPdfId => {
            try {
                this[NavigationMixin.Navigate]({
                    type: "standard__namedPage",
                    attributes: {
                        pageName: 'filePreview'
                    },
                    state: {
                        selectedRecordId: properPdfId
                    }
                });
            } catch (error) {
                console.error(error);
            }
        });
}

// save values from a radio button to the database
function radioChange(event) {
    let value = event.target.value;
    let valueId = event.target.dataset.id;
    if (this.currentChecklistId) {
        updateRadioValue({ currentChecklistId: this.currentChecklistId, valueId: valueId, value: value })
            .then(resp => {
                if (resp.isSuccess) {
                    console.log('success');
                } else {
                    const errorEvent = new ShowToastEvent({
                        title: 'Save error',
                        variant: 'error',
                        mode: 'sticky',
                        message: resp.responseObj
                    });
                    this.dispatchEvent(errorEvent);
                }
            })
            .catch(error => {
                const noResponseEvent = new ShowToastEvent({
                    title: 'Save error',
                    variant: 'error',
                    mode: 'sticky',
                    message: 'No response / saving: ' + error.body.message
                });
                this.dispatchEvent(noResponseEvent);
            })
    }
}

export { openReference, radioChange, options };