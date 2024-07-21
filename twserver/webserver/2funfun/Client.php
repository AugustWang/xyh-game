<?php
// SoapClient {
//     /* 方法 */
//
//     public mixed __call ( string $function_name , string $arguments )
//     public SoapClient ( mixed $wsdl [, array $options ] )
//     public string __doRequest ( string $request , string $location , string $action , int $version [, int $one_way = 0 ] )
//     public array __getFunctions ( void )
//     public string __getLastRequest ( void )
//     public string __getLastRequestHeaders ( void )
//     public string __getLastResponse ( void )
//     public string __getLastResponseHeaders ( void )
//     public array __getTypes ( void )
//     public void __setCookie ( string $name [, string $value ] )
//     public string __setLocation ([ string $new_location ] )
//     public bool __setSoapHeaders ([ mixed $soapheaders ] )
//     public mixed __soapCall ( string $function_name , array $arguments [, array $options [, mixed $input_headers [, array &$output_headers ]]] )
//     public SoapClient ( mixed $wsdl [, array $options ] )
// }
header('Content-Type: text/html; charset=UTF-8');

$soapUsername = 'wasai';//your soap username
$soapPassword = 'waX!sa1joMwONq';//your soap password 同时为您的MD5KEY。请注意保密
$gameId = 'wasai';//你的应用或者游戏编号

$client = new SoapClient('http://www.2funfun.com/api/v2_soap/?wsdl');
echo "<pre>";
echo $sessionId = $client->login($soapUsername, $soapPassword);
// $funs = $client->__getFunctions();
print_r($funs);
echo "</pre>";
// $parm=array('mobileCode'=>'13782149159','userID'=>'');
// $result=$client->getMobileCodeInfo($parm);
// $result=get_object_vars($result);   //将stdclass object转换为array,这个比较重要了
// echo "你的手机卡信息：".$result['getMobileCodeInfoResult'];
// try{
//     //wsdl方式调用web service
//     //wsdl方式中由于wsdl文件写定了，如果发生添加删除函数等操作改动，不会反应到wsdl，相对non-wsdl方式
//     //来说不够灵活
//     //$soap = new SoapClient("http://localhost/Test/MyService/PersonInfo.wsdl");
//     
//     //non-wsdl方式调用web service    
//     //在non-wsdl方式中option location系必须提供的,而服务端的location是选择性的，可以不提供
//     $soap = new SoapClient(null,array('location'=>"http://mst.my/soap/Server.php",'uri'=>'Server.php'));
//     
//     //两种调用方式，直接调用方法，和用__soapCall简接调用
//     $result1 = $soap->getName();
//     $result2 = $soap->__soapCall("getName",array());
//     echo $result1."<br/>";
//     echo $result2;
//     
// }catch(SoapFault $e){
//     echo $e->getMessage();
// }catch(Exception $e){
//     echo $e->getMessage();
// }

// Array
// (
//     [0] => boolean endSession(string $sessionId)
//     [1] => string login(string $username, string $apiKey)
//     [2] => string startSession()
//     [3] => ArrayOfApis resources(string $sessionId)
//     [4] => ArrayOfExistsFaltures globalFaults(string $sessionId)
//     [5] => ArrayOfExistsFaltures resourceFaults(string $resourceName, string $sessionId)
//     [6] => storeEntityArray storeList(string $sessionId)
//     [7] => storeEntity storeInfo(string $sessionId, string $storeId)
//     [8] => magentoInfoEntity magentoInfo(string $sessionId)
//     [9] => directoryCountryEntityArray directoryCountryList(string $sessionId)
//     [10] => directoryRegionEntityArray directoryRegionList(string $sessionId, string $country)
//     [11] => customerCustomerEntityArray customerCustomerList(string $sessionId, filters $filters)
//     [12] => customerCustomerEntityArray customerCustomerLogin(string $sessionId, filters $filters)
//     [13] => int customerCustomerCreate(string $sessionId, customerCustomerEntityToCreate $customerData)
//     [14] => customerCustomerEntity customerCustomerInfo(string $sessionId, int $customerId, ArrayOfString $attributes)
//     [15] => boolean customerCustomerUpdate(string $sessionId, int $customerId, customerCustomerEntityToCreate $customerData)
//     [16] => boolean customerCustomerDelete(string $sessionId, int $customerId)
//     [17] => customerGroupEntityArray customerGroupList(string $sessionId)
//     [18] => customerAddressEntityArray customerAddressList(string $sessionId, int $customerId)
//     [19] => int customerAddressCreate(string $sessionId, int $customerId, customerAddressEntityCreate $addressData)
//     [20] => customerAddressEntityItem customerAddressInfo(string $sessionId, int $addressId)
//     [21] => boolean customerAddressUpdate(string $sessionId, int $addressId, customerAddressEntityCreate $addressData)
//     [22] => boolean customerAddressDelete(string $sessionId, int $addressId)
//     [23] => int catalogCategoryCurrentStore(string $sessionId, string $storeView)
//     [24] => catalogCategoryTree catalogCategoryTree(string $sessionId, string $parentId, string $storeView)
//     [25] => ArrayOfCatalogCategoryEntitiesNoChildren catalogCategoryLevel(string $sessionId, string $website, string $storeView, string $parentCategory)
//     [26] => catalogCategoryInfo catalogCategoryInfo(string $sessionId, int $categoryId, string $storeView, ArrayOfString $attributes)
//     [27] => int catalogCategoryCreate(string $sessionId, int $parentId, catalogCategoryEntityCreate $categoryData, string $storeView)
//     [28] => boolean catalogCategoryUpdate(string $sessionId, int $categoryId, catalogCategoryEntityCreate $categoryData, string $storeView)
//     [29] => boolean catalogCategoryMove(string $sessionId, int $categoryId, int $parentId, string $afterId)
//     [30] => boolean catalogCategoryDelete(string $sessionId, int $categoryId)
//     [31] => catalogAssignedProductArray catalogCategoryAssignedProducts(string $sessionId, int $categoryId)
//     [32] => boolean catalogCategoryAssignProduct(string $sessionId, int $categoryId, string $product, string $position, string $productIdentifierType)
//     [33] => boolean catalogCategoryUpdateProduct(string $sessionId, int $categoryId, string $product, string $position, string $productIdentifierType)
//     [34] => boolean catalogCategoryRemoveProduct(string $sessionId, int $categoryId, string $product, string $productIdentifierType)
//     [35] => int catalogProductCurrentStore(string $sessionId, string $storeView)
//     [36] => catalogAttributeEntityArray catalogProductListOfAdditionalAttributes(string $sessionId, string $productType, string $attributeSetId)
//     [37] => catalogProductEntityArray catalogProductList(string $sessionId, filters $filters, string $storeView)
//     [38] => catalogProductReturnEntity catalogProductInfo(string $sessionId, string $product, string $storeView, catalogProductRequestAttributes $attributes, string $productIdentifierType)
//     [39] => int catalogProductCreate(string $sessionId, string $type, string $set, string $sku, catalogProductCreateEntity $productData, string $storeView)
//     [40] => boolean catalogProductUpdate(string $sessionId, string $product, catalogProductCreateEntity $productData, string $storeView, string $productIdentifierType)
//     [41] => int catalogProductSetSpecialPrice(string $sessionId, string $product, string $specialPrice, string $fromDate, string $toDate, string $storeView, string $productIdentifierType)
//     [42] => catalogProductReturnEntity catalogProductGetSpecialPrice(string $sessionId, string $product, string $storeView, string $productIdentifierType)
//     [43] => int catalogProductDelete(string $sessionId, string $product, string $productIdentifierType)
//     [44] => int catalogProductAttributeCurrentStore(string $sessionId, string $storeView)
//     [45] => int catalogProductAttributeSetCreate(string $sessionId, string $attributeSetName, string $skeletonSetId)
//     [46] => catalogAttributeEntityArray catalogProductAttributeList(string $sessionId, int $setId)
//     [47] => catalogAttributeOptionEntityArray catalogProductAttributeOptions(string $sessionId, string $attributeId, string $storeView)
//     [48] => boolean catalogProductAttributeSetRemove(string $sessionId, string $attributeSetId, string $forceProductsRemove)
//     [49] => catalogProductAttributeSetEntityArray catalogProductAttributeSetList(string $sessionId)
//     [50] => boolean catalogProductAttributeSetAttributeAdd(string $sessionId, string $attributeId, string $attributeSetId, string $attributeGroupId, string $sortOrder)
//     [51] => boolean catalogProductAttributeSetAttributeRemove(string $sessionId, string $attributeId, string $attributeSetId)
//     [52] => int catalogProductAttributeSetGroupAdd(string $sessionId, string $attributeSetId, string $groupName)
//     [53] => boolean catalogProductAttributeSetGroupRename(string $sessionId, string $groupId, string $groupName)
//     [54] => boolean catalogProductAttributeSetGroupRemove(string $sessionId, string $attributeGroupId)
//     [55] => catalogAttributeOptionEntityArray catalogProductAttributeTypes(string $sessionId)
//     [56] => int catalogProductAttributeCreate(string $sessionId, catalogProductAttributeEntityToCreate $data)
//     [57] => int catalogCategoryAttributeCurrentStore(string $sessionId, string $storeView)
//     [58] => int catalogProductAttributeMediaCurrentStore(string $sessionId, string $storeView)
//     [59] => boolean catalogProductAttributeRemove(string $sessionId, string $attribute)
//     [60] => catalogProductAttributeEntity catalogProductAttributeInfo(string $sessionId, string $attribute)
//     [61] => boolean catalogProductAttributeUpdate(string $sessionId, string $attribute, catalogProductAttributeEntityToUpdate $data)
//     [62] => boolean catalogProductAttributeAddOption(string $sessionId, string $attribute, catalogProductAttributeOptionEntityToAdd $data)
//     [63] => boolean catalogProductAttributeRemoveOption(string $sessionId, string $attribute, string $optionId)
//     [64] => catalogProductTypeEntityArray catalogProductTypeList(string $sessionId)
//     [65] => catalogProductTierPriceEntityArray catalogProductAttributeTierPriceInfo(string $sessionId, string $product, string $productIdentifierType)
//     [66] => int catalogProductAttributeTierPriceUpdate(string $sessionId, string $product, catalogProductTierPriceEntityArray $tier_price, string $productIdentifierType)
//     [67] => catalogAttributeEntityArray catalogCategoryAttributeList(string $sessionId)
//     [68] => catalogAttributeOptionEntityArray catalogCategoryAttributeOptions(string $sessionId, string $attributeId, string $storeView)
//     [69] => catalogProductImageEntityArray catalogProductAttributeMediaList(string $sessionId, string $product, string $storeView, string $productIdentifierType)
//     [70] => catalogProductImageEntity catalogProductAttributeMediaInfo(string $sessionId, string $product, string $file, string $storeView, string $productIdentifierType)
//     [71] => catalogProductAttributeMediaTypeEntityArray catalogProductAttributeMediaTypes(string $sessionId, string $setId)
//     [72] => string catalogProductAttributeMediaCreate(string $sessionId, string $product, catalogProductAttributeMediaCreateEntity $data, string $storeView, string $productIdentifierType)
//     [73] => boolean catalogProductAttributeMediaUpdate(string $sessionId, string $product, string $file, catalogProductAttributeMediaCreateEntity $data, string $storeView, string $productIdentifierType)
//     [74] => boolean catalogProductAttributeMediaRemove(string $sessionId, string $product, string $file, string $productIdentifierType)
//     [75] => catalogProductLinkEntityArray catalogProductLinkList(string $sessionId, string $type, string $product, string $productIdentifierType)
//     [76] => boolean catalogProductLinkAssign(string $sessionId, string $type, string $product, string $linkedProduct, catalogProductLinkEntity $data, string $productIdentifierType)
//     [77] => boolean catalogProductLinkUpdate(string $sessionId, string $type, string $product, string $linkedProduct, catalogProductLinkEntity $data, string $productIdentifierType)
//     [78] => boolean catalogProductLinkRemove(string $sessionId, string $type, string $product, string $linkedProduct, string $productIdentifierType)
//     [79] => ArrayOfString catalogProductLinkTypes(string $sessionId)
//     [80] => catalogProductLinkAttributeEntityArray catalogProductLinkAttributes(string $sessionId, string $type)
//     [81] => boolean catalogProductCustomOptionAdd(string $sessionId, string $productId, catalogProductCustomOptionToAdd $data, string $store)
//     [82] => boolean catalogProductCustomOptionUpdate(string $sessionId, string $optionId, catalogProductCustomOptionToUpdate $data, string $store)
//     [83] => catalogProductCustomOptionInfoEntity catalogProductCustomOptionInfo(string $sessionId, string $optionId, string $store)
//     [84] => catalogProductCustomOptionTypesArray catalogProductCustomOptionTypes(string $sessionId)
//     [85] => catalogProductCustomOptionValueInfoEntity catalogProductCustomOptionValueInfo(string $sessionId, string $valueId, string $store)
//     [86] => catalogProductCustomOptionValueListArray catalogProductCustomOptionValueList(string $sessionId, string $optionId, string $store)
//     [87] => boolean catalogProductCustomOptionValueAdd(string $sessionId, string $optionId, catalogProductCustomOptionValueAddArray $data, string $store)
//     [88] => boolean catalogProductCustomOptionValueUpdate(string $sessionId, string $valueId, catalogProductCustomOptionValueUpdateEntity $data, string $storeId)
//     [89] => boolean catalogProductCustomOptionValueRemove(string $sessionId, string $valueId)
//     [90] => catalogProductCustomOptionListArray catalogProductCustomOptionList(string $sessionId, string $productId, string $store)
//     [91] => boolean catalogProductCustomOptionRemove(string $sessionId, string $optionId)
//     [92] => salesOrderListEntityArray salesOrderList(string $sessionId, filters $filters)
//     [93] => salesOrderEntity salesOrderInfo(string $sessionId, string $orderIncrementId)
//     [94] => boolean salesOrderAddComment(string $sessionId, string $orderIncrementId, string $status, string $comment, string $notify)
//     [95] => boolean salesOrderHold(string $sessionId, string $orderIncrementId)
//     [96] => boolean salesOrderUnhold(string $sessionId, string $orderIncrementId)
//     [97] => boolean salesOrderCancel(string $sessionId, string $orderIncrementId)
//     [98] => salesOrderShipmentEntityArray salesOrderShipmentList(string $sessionId, filters $filters)
//     [99] => salesOrderShipmentEntity salesOrderShipmentInfo(string $sessionId, string $shipmentIncrementId)
//     [100] => string salesOrderShipmentCreate(string $sessionId, string $orderIncrementId, orderItemIdQtyArray $itemsQty, string $comment, int $email, int $includeComment)
//     [101] => boolean salesOrderShipmentAddComment(string $sessionId, string $shipmentIncrementId, string $comment, string $email, string $includeInEmail)
//     [102] => int salesOrderShipmentAddTrack(string $sessionId, string $shipmentIncrementId, string $carrier, string $title, string $trackNumber)
//     [103] => boolean salesOrderShipmentSendInfo(string $sessionId, string $shipmentIncrementId, string $comment)
//     [104] => boolean salesOrderShipmentRemoveTrack(string $sessionId, string $shipmentIncrementId, string $trackId)
//     [105] => associativeArray salesOrderShipmentGetCarriers(string $sessionId, string $orderIncrementId)
//     [106] => salesOrderInvoiceEntityArray salesOrderInvoiceList(string $sessionId, filters $filters)
//     [107] => salesOrderInvoiceEntity salesOrderInvoiceInfo(string $sessionId, string $invoiceIncrementId)
//     [108] => string salesOrderInvoiceCreate(string $sessionId, string $invoiceIncrementId, orderItemIdQtyArray $itemsQty, string $comment, string $email, string $includeComment)
//     [109] => boolean salesOrderInvoiceAddComment(string $sessionId, string $invoiceIncrementId, string $comment, string $email, string $includeComment)
//     [110] => boolean salesOrderInvoiceCapture(string $sessionId, string $invoiceIncrementId)
//     [111] => boolean salesOrderInvoiceVoid(string $sessionId, string $invoiceIncrementId)
//     [112] => boolean salesOrderInvoiceCancel(string $sessionId, string $invoiceIncrementId)
//     [113] => salesOrderCreditmemoEntityArray salesOrderCreditmemoList(string $sessionId, filters $filters)
//     [114] => salesOrderCreditmemoEntity salesOrderCreditmemoInfo(string $sessionId, string $creditmemoIncrementId)
//     [115] => string salesOrderCreditmemoCreate(string $sessionId, string $creditmemoIncrementId, salesOrderCreditmemoData $creditmemoData, string $comment, int $notifyCustomer, int $includeComment, string $refundToStoreCreditAmount)
//     [116] => boolean salesOrderCreditmemoAddComment(string $sessionId, string $creditmemoIncrementId, string $comment, int $notifyCustomer, int $includeComment)
//     [117] => boolean salesOrderCreditmemoCancel(string $sessionId, string $creditmemoIncrementId)
//     [118] => catalogInventoryStockItemEntityArray catalogInventoryStockItemList(string $sessionId, ArrayOfString $products)
//     [119] => int catalogInventoryStockItemUpdate(string $sessionId, string $product, catalogInventoryStockItemUpdateEntity $data)
//     [120] => int shoppingCartCreate(string $sessionId, string $storeId)
//     [121] => shoppingCartInfoEntity shoppingCartInfo(string $sessionId, int $quoteId, string $storeId)
//     [122] => shoppingCartTotalsEntityArray shoppingCartTotals(string $sessionId, int $quoteId, string $storeId)
//     [123] => string shoppingCartOrder(string $sessionId, int $quoteId, string $storeId, ArrayOfString $licenses)
//     [124] => shoppingCartLicenseEntityArray shoppingCartLicense(string $sessionId, int $quoteId, string $storeId)
//     [125] => boolean shoppingCartProductAdd(string $sessionId, int $quoteId, shoppingCartProductEntityArray $products, string $storeId)
//     [126] => boolean shoppingCartProductUpdate(string $sessionId, int $quoteId, shoppingCartProductEntityArray $products, string $storeId)
//     [127] => boolean shoppingCartProductRemove(string $sessionId, int $quoteId, shoppingCartProductEntityArray $products, string $storeId)
//     [128] => shoppingCartProductResponseEntityArray shoppingCartProductList(string $sessionId, int $quoteId, string $storeId)
//     [129] => boolean shoppingCartProductMoveToCustomerQuote(string $sessionId, int $quoteId, shoppingCartProductEntityArray $products, string $storeId)
//     [130] => boolean shoppingCartCustomerSet(string $sessionId, int $quoteId, shoppingCartCustomerEntity $customer, string $storeId)
//     [131] => boolean shoppingCartCustomerAddresses(string $sessionId, int $quoteId, shoppingCartCustomerAddressEntityArray $customer, string $storeId)
//     [132] => boolean shoppingCartShippingMethod(string $sessionId, int $quoteId, string $method, string $storeId)
//     [133] => shoppingCartShippingMethodEntityArray shoppingCartShippingList(string $sessionId, int $quoteId, string $storeId)
//     [134] => boolean shoppingCartPaymentMethod(string $sessionId, int $quoteId, shoppingCartPaymentMethodEntity $method, string $storeId)
//     [135] => shoppingCartPaymentMethodResponseEntityArray shoppingCartPaymentList(string $sessionId, int $quoteId, string $storeId)
//     [136] => boolean shoppingCartCouponAdd(string $sessionId, int $quoteId, string $couponCode, string $storeId)
//     [137] => boolean shoppingCartCouponRemove(string $sessionId, int $quoteId, string $storeId)
//     [138] => catalogProductTagListEntityArray catalogProductTagList(string $sessionId, string $productId, string $store)
//     [139] => catalogProductTagInfoEntity catalogProductTagInfo(string $sessionId, string $tagId, string $store)
//     [140] => associativeArray catalogProductTagAdd(string $sessionId, catalogProductTagAddEntity $data)
//     [141] => boolean catalogProductTagUpdate(string $sessionId, string $tagId, catalogProductTagUpdateEntity $data, string $store)
//     [142] => boolean catalogProductTagRemove(string $sessionId, string $tagId)
//     [143] => giftMessageResponse giftMessageSetForQuote(string $sessionId, string $quoteId, giftMessageEntity $giftMessage, string $storeId)
//     [144] => giftMessageResponse giftMessageSetForQuoteItem(string $sessionId, string $quoteItemId, giftMessageEntity $giftMessage, string $storeId)
//     [145] => giftMessageResponseArray giftMessageSetForQuoteProduct(string $sessionId, string $quoteId, giftMessageAssociativeProductsEntityArray $productsAndMessages, string $storeId)
//     [146] => int catalogProductDownloadableLinkAdd(string $sessionId, string $productId, catalogProductDownloadableLinkAddEntity $resource, string $resourceType, string $store, string $identifierType)
//     [147] => catalogProductDownloadableLinkInfoEntity catalogProductDownloadableLinkList(string $sessionId, string $productId, string $store, string $identifierType)
//     [148] => boolean catalogProductDownloadableLinkRemove(string $sessionId, string $linkId, string $resourceType)
// )
?>
