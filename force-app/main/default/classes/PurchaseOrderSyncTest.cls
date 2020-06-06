@isTest
public with sharing class PurchaseOrderSyncTest {
    @isTest
    static void testPoSyncGood() {
        Purchase_Order__c po = new Purchase_Order__c();
        po.Name = 'Shell PO';
        po.Purchase_Order_Id__c = 'abc123';
        insert po;

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new PurchaseOrderMock(200));
            Integer statusCode = PurchaseOrderSync.syncPo(po.Purchase_Order_Id__c, po.Id);
        Test.stopTest();

        System.assertEquals(200, statusCode, 'Status Code should be 200');
        Purchase_Order__c updatedPo = [SELECT Name, Amount__c, Amount_Still_Owed__c, Description__c FROM Purchase_Order__c WHERE Id = :po.Id];
        System.assertEquals('Dreamforce Astro Purchase', updatedPo.Name, 'Name should be the value from mock');
        System.assertEquals(150000.00, updatedPo.Amount__c, 'Amount should be the value from mock');
        System.assertEquals(10000.00, updatedPo.Amount_Still_Owed__c, 'Amount Owed should be the value from mock');
        System.assertEquals('Astro plushies for DF', updatedPo.Description__c, 'Description should be the value from mock');
    }

    @isTest
    static void testPoSyncAuthFail() {
        Purchase_Order__c po = new Purchase_Order__c();
        po.Name = 'Shell PO';
        po.Purchase_Order_Id__c = 'abc123';
        insert po;

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new PurchaseOrderMock(403));
            Integer statusCode = PurchaseOrderSync.syncPo(po.Purchase_Order_Id__c, po.Id);
        Test.stopTest();

        System.assertEquals(403, statusCode, 'Status Code should be 403');
        Purchase_Order__c updatedPo = [SELECT Name, Amount__c, Amount_Still_Owed__c, Description__c FROM Purchase_Order__c WHERE Id = :po.Id];
        System.assertEquals(po.Name, updatedPo.Name, 'Name should not be updated');
        System.assertEquals(null, updatedPo.Amount__c, 'Amount should not be updated');
        System.assertEquals(null, updatedPo.Amount_Still_Owed__c, 'Amount Owed should not be updated');
        System.assertEquals(null, updatedPo.Description__c, 'Description should not be updated');     
    }

    @isTest
    static void testPoSyncServerFail() {
        Purchase_Order__c po = new Purchase_Order__c();
        po.Name = 'Shell PO';
        po.Purchase_Order_Id__c = 'abc123';
        insert po;

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new PurchaseOrderMock(500));
            Integer statusCode = PurchaseOrderSync.syncPo(po.Purchase_Order_Id__c, po.Id);
        Test.stopTest();

        System.assertEquals(500, statusCode, 'Status Code should be 500');
        Purchase_Order__c updatedPo = [SELECT Name, Amount__c, Amount_Still_Owed__c, Description__c FROM Purchase_Order__c WHERE Id = :po.Id];
        System.assertEquals(po.Name, updatedPo.Name, 'Name should not be updated');
        System.assertEquals(null, updatedPo.Amount__c, 'Amount should not be updated');
        System.assertEquals(null, updatedPo.Amount_Still_Owed__c, 'Amount Owed should not be updated');
        System.assertEquals(null, updatedPo.Description__c, 'Description should not be updated');
    }

    @isTest
    static void testStaticResource() {
        Purchase_Order__c po = new Purchase_Order__c();
        po.Name = 'Shell PO';
        po.Purchase_Order_Id__c = 'abc123';
        insert po;

        Test.startTest();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('purchaseOrderResponse');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json');
            Test.setMock(HttpCalloutMock.class, mock);
            Integer statusCode = PurchaseOrderSync.syncPo(po.Purchase_Order_Id__c, po.Id);
        Test.stopTest();

        System.assertEquals(200, statusCode, 'Status Code should be 200');
        Purchase_Order__c updatedPo = [SELECT Name, Amount__c, Amount_Still_Owed__c, Description__c FROM Purchase_Order__c WHERE Id = :po.Id];
        System.assertEquals('Dreamforce Astro Purchase', updatedPo.Name, 'Name should be the value from mock');
        System.assertEquals(150000.00, updatedPo.Amount__c, 'Amount should be the value from mock');
        System.assertEquals(10000.00, updatedPo.Amount_Still_Owed__c, 'Amount Owed should be the value from mock');
        System.assertEquals('Astro plushies for DF', updatedPo.Description__c, 'Description should be the value from mock');
    }
}
