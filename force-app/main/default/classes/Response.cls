public with sharing class Response {
    @AuraEnabled
    public Object responseObj { get; set; }
    @AuraEnabled
    public Boolean isSuccess { get; set; }
    
    public Response() {
        this.isSuccess = true;
    }

    public Response(Boolean status, String message){
        this.isSuccess = status;
        this.responseObj = message;
    }

    public Response(Object pResponseObj){
        this.isSuccess = true;
        this.responseObj = pResponseObj;
    }

}
