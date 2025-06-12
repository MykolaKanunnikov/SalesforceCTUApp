import { api, LightningElement } from "lwc";
import {
    options,
    namespacePrefix
    
} from "c/radioGroupButtonAndHelp";


export default class QuestionAnswer extends LightningElement {
    @api title;
    @api fieldValue;
    @api fieldPath
    @api values;
    currentValue;
    
    options = options();

    handleChange(event) {
        this.dispatchEvent(new CustomEvent('answer',{detail: {
            value: event.target.value,
            field: this.fieldPath,
            fieldWithPrefix: namespacePrefix + this.fieldPath
        } }));
    }

    connectedCallback(){
        let fieldReferenceToGetValue = "ctuapptest__" + this.fieldPath
        this.currentValue = this.values[fieldReferenceToGetValue]
    }
    
}
