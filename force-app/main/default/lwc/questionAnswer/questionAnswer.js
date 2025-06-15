import { api, LightningElement } from "lwc";

export default class QuestionAnswer extends LightningElement {
    @api title;
    @api fieldValue;
    @api fieldPath;
    @api values;
    currentValue;

    options = [
        { label: "YES", value: "YES" },
        { label: "NO", value: "NO" },
        { label: "N/A", value: "N/A" }
    ];

handleChange(event) {
    this.dispatchEvent(
        new CustomEvent("answer", {
            detail: {
                value: event.target.value,
                field: this.fieldPath,
                fieldWithPrefix: "ctuapptest__" + this.fieldPath
            },
            bubbles: true,
            composed: true
        })
    );
}


    connectedCallback() {
        let fieldReferenceToGetValue = "ctuapptest__" + this.fieldPath;
        this.currentValue = this.values[fieldReferenceToGetValue];
    }
}
