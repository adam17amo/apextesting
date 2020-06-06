@isTest
global with sharing class PurchaseOrderMock implements HttpCalloutMock{
    // Can also take the Map approach: https://developer.salesforce.com/blogs/developer-relations/2013/03/testing-apex-callouts-using-httpcalloutmock.html
    public Integer statusCode;

    global PurchaseOrderMock(Integer statusCode) {
        this.statusCode = statusCode;
    }

    global HttpResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(statusCode);
        System.debug('Initial response is ' + response);

        if(statusCode == 200) {
            response.setStatus('OK');
            response.setBody(okResponse());
        } else if(statusCode == 403) {
            response.setStatus('AUTHENTICATION_FAILURE');
            response.setBody(authFailedResponse());
        } else if(statusCode == 500) {
            response.setStatus('INTERNAL_SERVER_ERROR');
            response.setBody(serverErrorResponse());
        }

        System.debug('Returned response is ' + response);
        System.debug('Body is ' + response.getBody());
        return response;
    }

    private String okResponse() {
        String body = '{' +
                    '"results" : [' +
                    '{' +
                    '"poId" : "abc123",' +
                    '"name" : "Dreamforce Astro Purchase",' +
                    '"amount" : 150000.00,' +
                    '"amountRemaining" : 10000.00,' +
                    '"description" : "Astro plushies for DF"' +
                    '}' +
                    '],' +
                    '"status" : "OK",' +
                    '"statusCode" : 200' +
                    '}';

        return body;
    }

    private String authFailedResponse() {
        String body = '{' +
                    '"results" : []' +
                    '"status" : "AUTHENTICATION_FAILURE"' +
                    '"statusCode" : 403' +
                    '}';

        return body;
    }

    private String serverErrorResponse() {
        String body = '{' +
                    '"results" : []' +
                    '"status" : "INTERNAL_SERVER_ERROR"' +
                    '"statusCode" : 500' +
                    '}';
        return body;
    }
}
