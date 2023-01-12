public with sharing class Response {
    @AuraEnabled
    public Object responseObj { get; set; }
    @AuraEnabled
    public Boolean isSuccess { get; set; }
    
    public Response() {
        this.isSuccess = true;
    }

    public Response(Object pResponseObj){
        this.isSuccess = true;
        this.responseObj = pResponseObj;
    }

    public Response(Exception e){
        String respMessage = e.getMessage();
        if (e instanceof DmlException) {
            DmlException dmlEx = (DmlException)e;
            respMessage = dmlEx.getDmlMessage(0);
        }
        this.isSuccess = false;
        this.responseObj = respMessage;
    }
}