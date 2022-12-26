import { LightningElement } from 'lwc';
import formFactorPropertyName from '@salesforce/client/formFactor'
import modalReference from 'c/modalReference';
import CTUref from '@salesforce/resourceUrl/CTUref'
import {NavigationMixin} from 'lightning/navigation'
import getFileRecordId from '@salesforce/apex/ShipmentController.getFileRecordId';



export default class PackingArea1to7 extends NavigationMixin(LightningElement) {

    value = '';

    refCTU = CTUref + "/1.pdf";

    get options() {
        return [
            { label: 'YES', value: 'YES' },
            { label: 'NO', value: 'NO' },
            { label: 'N/A', value: 'N/A' },
        ];
    }

/*    handleClick(event){
        const itemId = event.target.dataset.id;
        const file = `/${itemId}.pdf`;
        let url = CTUref + file;
        console.log(url);
    if(formFactorPropertyName === 'Large'){
        modalReference.open({
        size: 'large'
        })
        }else{
             this[NavigationMixin.Navigate]({
                 "type": "standard__webPage",
                 "attributes": {
                     "url": url 
                 }
             });        
        }
    }  //
*/
    handleClick(event){
     //   if(formFactorPropertyName === 'Large'){
     //       modalReference.open({
      //          size: 'large'
     //       })
           // } else { 
                const itemId = event.target.dataset.id;
                const title = `${itemId}.pdf`;
                console.log(title);
                getFileRecordId(title)
                    .then(properPdfId => {
                        try{
                        console.log(properPdfId);
                        this[NavigationMixin.Navigate]({
                            type: 'standard__recordPage',
                            attributes: {
                                recordId: properPdfId,
                                objectApiName: 'ContentDocument',
                                actionName: 'view'
                            }
                        }); 
                        }catch(error){
                            console.error(error);
                        } 
                    })       
            }
 //   }  
}