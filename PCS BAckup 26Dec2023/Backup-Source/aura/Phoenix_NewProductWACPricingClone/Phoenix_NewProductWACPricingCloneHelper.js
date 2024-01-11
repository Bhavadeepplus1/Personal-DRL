({
    buildData: function (component, helper) {
        //window.scroll(0,0);
        var scrollOptions = {
            left: 0,
            top: 0,


            behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);
        var data = [];
        let selectedProductsIds = component.get("v.selectedProductsIds");
        console.log("%c--------selectedProductsIds-------" + selectedProductsIds, "background-color:red;color:white;");
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allData");
        console.log('Build data: '+JSON.stringify(allData));
        var x = (pageNumber - 1) * pageSize;
        var pData;
        var copyList = [];
        component.set("v.ProductCopyList", copyList);

        //creating data-table data
        for (; x < (pageNumber) * pageSize; x++) {
            pData = allData[x];
            if (pData) {
                pData.isSelected = false;
                if (selectedProductsIds.includes(pData.prdlist.Id)) {

                    pData.isSelected = true;
                }
                data.push(pData);
            }
        }
        console.log('Build data: '+JSON.stringify(data));
        component.set("v.ProductList", data);


        if (data.length > 0) {
            var selectCount = 0;
            for (var i = 0; i < data.length; i++) {
                if (data[i].isSelected == true) {
                    selectCount++;
                }
            }

            if (selectCount == pageSize || selectCount == i) {
                component.set("v.selectAll", true);

            } else {
                component.set("v.selectAll", false);
            }
        }

       helper.generatePageList(component, pageNumber, false);
    },
    showToast: function (params) {
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.setParams(params);
            toastEvent.fire();
        } else {
            alert(params.message);
        }
    },
    generatePageList: function (component, pageNumber, isFromContractView) {
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = isFromContractView ? component.get("v.totalPagesCount") : component.get("v.totalPages");
        if (totalPages > 1) {
            if (totalPages <= 10) {
                var counter = 2;
                for (; counter < (totalPages); counter++) {
                    pageList.push(counter);
                }
            } else {
                if (pageNumber < 5) {
                    pageList.push(2, 3, 4, 5, 6);
                } else {
                    if (pageNumber > (totalPages - 5)) {
                        pageList.push(totalPages - 5, totalPages - 4, totalPages - 3, totalPages - 2, totalPages - 1);
                    } else {
                        pageList.push(pageNumber - 2, pageNumber - 1, pageNumber, pageNumber + 1, pageNumber + 2);
                    }
                }
            }
        }
        component.set("v.pageList", pageList);
    },
})