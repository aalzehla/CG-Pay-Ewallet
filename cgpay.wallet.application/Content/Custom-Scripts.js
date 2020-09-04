if ($('.datatable').length > 0) {
    $(".datatable").dataTable({
        //dom: "<'datatable-header dt-buttons-right'fB><'datatable-scroll'tS><'datatable-footer'i>",
        language: {
            search: "<span>Filter:</span> _INPUT_",
            searchPlaceholder: "Type to filter...",
            lengthMenu: "<span>Show:</span> _MENU_",
            paginate: { "first": "First", "last": "Last", "next": $("html").attr("dir") == "rtl" ? "&larr;" : "&rarr;", "previous": $("html").attr("dir") == "rtl" ? "&rarr;" : "&larr;" }  
        },
        "autoWidth": false
    });
}
if ($('.datatable-report').length > 0) {
    $(".datatable-report").dataTable({
        //dom: "<'datatable-header dt-buttons-right'fB><'datatable-scroll'tS><'datatable-footer'i>",
        language: {
            search: "<span>Filter:</span> _INPUT_",
            searchPlaceholder: "Type to filter...",
            lengthMenu: "<span>Show:</span> _MENU_",
            paginate: { "first": "First", "last": "Last", "next": $("html").attr("dir") == "rtl" ? "&larr;" : "&rarr;", "previous": $("html").attr("dir") == "rtl" ? "&rarr;" : "&larr;" }
        },
        "autoWidth": false,
        "scrollX": true
    });
}
//Noty.overrideDefaults({

//});
//function ShowPopup(Code, Message) {
//    type = '';
//    if (Code === 1) {
//        type = 'error';
//    }
//    else if (Code === 0) {
//        type = 'success';
//    }
//    else if (Code === 2) {
//        type = 'warning';
//    }
//    new Noty({
//        text: Message,
//        type: type,
//        theme: "limitless",
//        layout: "topRight",
//        timeout: 2500
//    }).show();
//}
Noty.overrideDefaults({
    theme: "limitless",
    layout: "topRight",
    type: "alert",
    timeout: 2500
});

function ShowPopup(Code, Message) {
    type = '';
    if (Code == 1) {
        type = 'error';
    }
    else if (Code == 0) {
        type = 'success';
    }
    else if (Code == 2) {
        type = 'warning';
    }
    new Noty({
        text: Message,
        type: type
    }).show();
}
$(document).ready(function e() {
    if (!$().uniform) {
        console.warn('Warning - uniform.min.js is not loaded.');
        return;
    }
    if ($('.form-check-input-styled').length > 0) {
        $('.form-check-input-styled').uniform();
    }
    if (!$().bootstrapSwitch) {
        console.warn('Warning - switch.min.js is not loaded.');
        return;
    }
    if ($('.form-check-input-switch').length > 0) {
        $('.form-check-input-switch').bootstrapSwitch();
    }
    if (typeof(Switchery) == 'undefined') {
        console.warn('Warning - switchery.min.js is not loaded.');
        return;
    }
    if ($('.form-check-input-switchery').length > 0) {
        
        var elems = Array.prototype.slice.call(document.querySelectorAll('.form-check-input-switchery'));
        elems.forEach(function (html) {
            var switchery = new Switchery(html);
        });
        // Colored switches
        var primary = document.querySelector('.form-check-input-switchery-primary');
        var switcheryPrimary = new Switchery(primary, { color: '#2196F3' });

        var danger = document.querySelector('.form-check-input-switchery-danger');
        var switcheryDanger = new Switchery(danger, { color: '#EF5350' });

        var warning = document.querySelector('.form-check-input-switchery-warning');
        var switcheryWarning = new Switchery(warning, { color: '#FF7043' });

        var info = document.querySelector('.form-check-input-switchery-info');
        var switcheryInfo = new Switchery(info, { color: '#00BCD4' });
    }
});
///urls must begin with ~/
var urls = {
    BlockUser: '~/User/BlockUser',
    UnBlockUser: '~/User/UnBlockUser'
};
let ShowModal = new Function('modalId', 'if($("#"+modalId).length>0){$("#"+modalId).modal("show");}');
let HideModal = new Function('modalId', 'if($("#"+modalId).length>0){$("#"+modalId).modal("hide");}');
let SingleFieldModal = new Function('modalId', 'modalHeader', 'fieldId', 'fieldVal', 'formName', 'formAction', 'modalContent',
    'if($("#"+modalId).length>0 && $("#"+fieldId).length>0)' +
    '{' +
    '$("#"+modalId+" .modal-title").html(modalHeader);$("#"+modalId).modal("show");$("#"+fieldId).val(fieldVal);' +
    '$("#"+formName).attr("action",resolveurl(urls[formAction]));if($("#modalContentToDisplay").length>0){$("#modalContentToDisplay").html(modalContent);}' +
    '}');
//      if redirect is false 
//      dont use below line in controller
//      DbResponse.SetMessageInTempData(this);
let CallAjaxDbResponse = new Function('jsonData', 'url', 'method', 'redirect', 'evalText=""',
    '$.ajax({' +
    'url: resolveurl(url),' +
    'type: method,' +
    'data: jsonData,' +
    //'contentType: "contentType",' +
    'error: function () {' +
    'ShowPopup(1, "Something Went Wrong.");' +
    '},' +
    'success: function (response) {' +
    'if(redirect==true){window.location.reload();} ;if (response.ErrorCode == 0) {' +
    'eval(evalText);' +
    '}' +
    'else {' +
    'ShowPopup(1, response.Message);' +
    '}' +
    '}' +
    '});');
function showConfirmationModal(message, funcText, title = "Are you sure?") {
    bootbox.confirm({
        title: title,
        message: message,
        icon: "icon-remove",
        buttons: {
            confirm: {
                label: 'Yes',
                classname: 'btn-primary'
            },
            cancel: {
                label: 'Cancel',
                classname: 'btn-link'
            }
        },
        callback: function (result) {
            if (result) {
                eval(funcText);
            }
            return;
        }
    });
}

let DataTableWithExportToExcelTotal = new Function('className', 'getTotalOfColumns', 'footerdisplay', 'coulmnvisible',
    'if ($("."+className).length > 0) {' +
    '$("."+className).dataTable({' +
    'dom: "Blfrtip",' +
    '"lengthMenu": [[100, 200, 500,1000, -1], [100, 200, 500,1000, "All"]],' +
    'buttons: [{ extend: "excelHtml5",' +
    'exportOptions: { ' +
    'columns: coulmnvisible},' +
    'footer: footerdisplay }], ' +
    'language: {' +
    'search: "<span>Filter:</span> _INPUT_",' +
    'searchPlaceholder: "Type to filter...",' +
    'paginate: {' +
    '"first": "First", "last": "Last", "next": $("html").attr("dir") == "rtl" ? "&larr;" : "&rarr;", "previous": $("html").attr("dir") == "rtl" ? "&rarr; " : "&larr; "' +
    '}' +
    '},' +
    '"autoWidth": false,' +
    '"footerCallback": function (row, data, start, end, display) {' +
    'var api = this.api(), data;' +
    'var intVal = function (i) {' +
    'return typeof i === "string" ?' +
    'i.replace(/[\$,]/g, "") * 1 :' +
    'typeof i === "number" ?' +
    'i : 0;' +
    '};' +
    'for (let j = 0; j < getTotalOfColumns.length; j++) {' +
    'total = api' +
    '.column(getTotalOfColumns[j])' +
    '.data()' +
    '.reduce(function (a, b) {' +
    'return intVal(a) + intVal(b);' +
    '}, 0);' +
    'pageTotal = api' +
    '.column(getTotalOfColumns[j], { page: "current" })' +
    '.data()' +
    '.reduce(function (a, b) {' +
    'return intVal(a) + intVal(b);' +
    '}, 0);' +
    '$(api.column(getTotalOfColumns[j]).footer()).html(' +
    'pageTotal + " (" + total + " total)"' +
    ');' +
    '}' +
    '}' +



    '});' +
    '}');





function showDateTableWithExcelTotal(className, colArray, footerdisplay, columnvisible) {
    var columns = "";
    let visiblecols = "" //columnvisible.length == 0 ? "':visible'" : "";
    for (let k = 0; k < colArray.length; k++) {
        if (k >= colArray.length - 1) {
            columns += colArray[k];
        }
        else
            columns += colArray[k] + ","
    }



    for (let k = 0; k < columnvisible.length; k++) {
        if (k >= columnvisible.length - 1) {
            visiblecols += columnvisible[k];
        }
        else
            visiblecols += columnvisible[k] + ","
    }
    eval("DataTableWithExportToExcelTotal('" + className + "',[" + columns + "] ," + footerdisplay + ",[" + visiblecols + "]);");



}