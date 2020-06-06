public with sharing class PurchaseOrderSync {
    public static Integer syncPo(String poExtId, String poId) {
        HttpRequest req = new HttpRequest();
        HttpResponse res;
        Http h = new Http();
        req.setEndpoint('http://myPurchaseOrderSystem.com/purchaseOrders?id='+poExtId);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('GET');
        
        try {
            res = h.send(req);
            if(res.getStatusCode() == 200) {
                String responseBody = res.getBody();
                PurchaseOrderResult poFromSource =
                    (PurchaseOrderResult)JSON.deserialize(responseBody, PurchaseOrderResult.class);
                System.debug('API Result ' + poFromSource);
                if(!poFromSource.results.isEmpty()) {
                    updatePurchaseOrder(poId, poFromSource.results[0]);
                }
            } else {
                System.debug('Error syncing PO ' + res.getStatus());
            }
        } catch (Exception e) {
            System.debug('Problem with callout ' + e.getMessage());
        }
        return ((res != null) ? res.getStatusCode() : null);
    }

    private static void updatePurchaseOrder(String poId, PurchaseOrder poFromSource) {
        Purchase_Order__c purchaseOrderSfdc = [SELECT Amount__c, Amount_Still_Owed__c,
                                                Name, Description__c
                                                FROM Purchase_Order__c WHERE Id = :poId];

        purchaseOrderSfdc.Amount__c = poFromSource.amount;
        purchaseOrderSfdc.Amount_Still_Owed__c = poFromSource.amountRemaining;
        purchaseOrderSfdc.Description__c = poFromSource.description;
        purchaseOrderSfdc.Name = poFromSource.name;
        update purchaseOrderSfdc;
    }

    public class PurchaseOrderResult {
        public List<PurchaseOrder> results;
        public String status;
        public String statusCode;
    }

    public class PurchaseOrder {
        public String poId {get;set;}
        public String name {get;set;}
        public Decimal amount {get;set;}
        public Decimal amountRemaining {get;set;}
        public String description {get;set;}
    }
}
