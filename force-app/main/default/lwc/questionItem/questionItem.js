import { api, LightningElement } from 'lwc';
import { openReference } from 'c/radioGroupButtonAndHelp';
import { packingArea } from 'c/questions';


export default class QuestionItem extends LightningElement {
        @api recordId;
        questions;
        connectedCallback(){
        }
            // display a relevant reference file.
            handleClick(event) {
                openReference.call(this, event);
            }
}