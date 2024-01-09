import { LightningElement, track, api } from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import Calendar from '@salesforce/resourceUrl/Calendar';
import calendarCSS from '@salesforce/resourceUrl/calendarCSS';
import { NavigationMixin } from 'lightning/navigation';
import fetchOpportunitiesAndBids from '@salesforce/apex/CalenderController.fetchOpportunitiesAndBids';

export default class Calender extends NavigationMixin(LightningElement) {
    @api recordId;
    @track allEvents = [];
    @track selectedEvent = undefined;
    @track showModal = false;
    @track baseUrl;
    createRecord = false;
    showTooltip = false;

    connectedCallback() {
        console.log('calender connectedCallback starts');
        console.log('recordId: ' + this.recordId);
        this.baseUrl = window.location.origin;

        Promise.all([
            loadStyle(this, calendarCSS)
        ])
            .then(() => {
                console.log('calendarCSS and calendarJS file loaded');
            })
            .catch(error => {
                this.showNotification('Error!', 'calendarCSS not loaded. Please contact System Admministrator!', 'error');
                console.error('Error occured on Calendar static resource ' + error);
            });

        Promise.all([
            loadScript(this, Calendar + '/fullcalendar.min.js'),
            loadScript(this, Calendar + '/jquery.min.js'),
            loadScript(this, Calendar + '/moment.min.js'),
            loadScript(this, Calendar + '/theme.js')
        ])
            .then(() => {
                console.log('Calendar static resource loaded');
                this.getData();
            })
            .catch(error => {
                console.error('Error occured on Calendar static resource ' + error);
            })
    }

    initialiseFullCalendar() {
        const ele = this.template.querySelector('div.fullcalendarjs');
        $(ele).fullCalendar({
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,basicWeek,basicDay'
            },
            themeSystem: 'standard',
            defaultDate: new Date(),
            navLinks: true,
            editable: true,
            eventLimit: true,
            events: this.allEvents,
            dragScroll: true,
            droppable: true,
            weekNumbers: false,
            eventDrop: this.eventDropHandler.bind(this),
            eventClick: this.eventClickHandler.bind(this),
            dayClick: this.dayClickHandler.bind(this),
            eventMouseover: this.eventMouseoverHandler.bind(this),
            eventMouseout: this.eventMouseoutHandler.bind(this),
        });
    }

    eventMouseoverHandler = (calEvent, jsEvent, view) => {
        console.log('eventMouseoverHandler starts');
        let data;
        if (calEvent.type == 'Bid') {
            data = '<b>Name: </b>' + calEvent.title + '<br/>' + '<b>Approval Status: </b>' + calEvent.status + '<br/>' + '<b>Internal Target Date: </b>' + calEvent.internalClosingDate + '<br/>' + '<b>Customer Closing Date: </b>' + calEvent.customerClosingDate + '<br/>';
        }
        else{
            data = '<b>Name: </b>' + calEvent.title + '<br/>';
        }

        var tooltip = '<div class="tooltipevent slds-popover slds-popover_tooltip" role="tooltip" id="help" style="position:absolute;top:-4px;left:35px">  <div class="slds-popover__body">' + data + '</div> </div>';
        var $tooltip = $(tooltip).appendTo('body');

        // var tooltip = '<div class="tooltipevent" style="width:100px;height:100px;background:#ccc;position:absolute;z-index:10001;">' + calEvent.title + '</div>';
        // var $tooltip = $(tooltip).appendTo('body');

        $(this).mouseover(function (e) {
            $(this).css('z-index', 10000);
            $tooltip.fadeIn('500');
            $tooltip.fadeTo('10', 1.9);
        }).mousemove(function (e) {
            $tooltip.css('top', e.pageY + 10);
            $tooltip.css('left', e.pageX + 20);
        });

    }

    eventMouseoutHandler = (calEvent, jsEvent) => {
        console.log('eventMouseoutHandler starts');
        $(this).css('z-index', 8);
        $('.tooltipevent').remove();
    }

    eventDropHandler = (event, delta, revertFunc) => {
        console.log('eventDropHandler starts');
    }

    eventClickHandler = (event, jsEvent, view) => {
        console.log('eventClickHandler starts');
        this.selectedEvent = event;
        let url = this.baseUrl + '/' + this.selectedEvent.id;
        window.open(url, '_blank').focus();
    }

    dayClickHandler = (date, jsEvent, view) => {
        console.log('dayClickHandler starts');
        jsEvent.preventDefault();
        this.createRecord = true;
    }

    createCancel() {
        console.log('createCancel starts');
        this.createRecord = false;
    }

    getData() {
        fetchOpportunitiesAndBids({ accountId: this.recordId })
            .then(result => {
                if (result) {
                    let data = [];
                    const currentDate = new Date().toISOString().split('T')[0];
                    console.log('currentDate: ' + currentDate);

                    for (let item of result) {
                        if (item.type == 'Opportunity') {
                            if (item.internalClosingDate < currentDate) {
                                if (item.status == 'Opportunity in progress' || item.status == 'Sent to BRIGHT') {
                                    data.push({
                                        id: item.id,
                                        editable: false,
                                        title: item.name,
                                        name: item.name,
                                        start: item.internalClosingDate,
                                        end: item.internalClosingDate,
                                        type: 'Opportunity',
                                        status: item.status,
                                        backgroundColor: "rgb(255,0,0)", // Red
                                        borderColor: "rgb(255,0,0)"
                                    });
                                }
                                else if (item.status == 'Completed' || item.status == 'Closed Lost') {
                                    data.push({
                                        id: item.id,
                                        editable: false,
                                        title: item.name,
                                        name: item.name,
                                        start: item.internalClosingDate,
                                        end: item.internalClosingDate,
                                        type: 'Opportunity',
                                        status: item.status,
                                        backgroundColor: "rgb(0,128,0)",  // Green
                                        borderColor: "rgb(0,128,0)"
                                    });
                                }
                            }
                            else {
                                if (item.status == 'Opportunity in progress' || item.status == 'Sent to BRIGHT') {
                                    data.push({
                                        id: item.id,
                                        editable: false,
                                        title: item.name,
                                        name: item.name,
                                        start: item.internalClosingDate,
                                        end: item.internalClosingDate,
                                        type: 'Opportunity',
                                        status: item.status,
                                        backgroundColor: "rgb(255,140,0)",  // Orange
                                        borderColor: "rgb(255,140,0)"
                                    });
                                }
                                else if (item.status == 'Completed' || item.status == 'Closed Lost') {
                                    data.push({
                                        id: item.id,
                                        editable: false,
                                        title: item.name,
                                        name: item.name,
                                        start: item.internalClosingDate,
                                        end: item.internalClosingDate,
                                        type: 'Opportunity',
                                        status: item.status,
                                        backgroundColor: "rgb(0,128,0)", // Green
                                        borderColor: "rgb(0,128,0)"
                                    });
                                }
                            }
                        }
                        else if (item.type == 'Bid') {
                            let customerUpdate1 = "Customer" + "'s " + 'Update';
                            let customerUpdate2 = "Customner" + "'s " + 'Update';
                            if (item.internalClosingDate < currentDate) {
                                if (item.status == 'Closed' || item.status == 'Closed-Vistex Update' || item.status == 'Customer' || item.status == customerUpdate1 || item.status == customerUpdate2 || item.status == 'Customer Pending' || item.status == 'Customer Rejected' || item.status == 'Customer Service Rejected' || item.status == 'Vistex Update' || item.status == 'Vistex Update Rejected') {
                                    data.push({
                                        id: item.id,
                                        editable: false,
                                        title: item.name,
                                        name: item.name,
                                        start: item.internalClosingDate,
                                        end: item.internalClosingDate,
                                        type: 'Bid',
                                        status: item.status,
                                        internalClosingDate: item.internalClosingDate,
                                        customerClosingDate: item.customerClosingDate,
                                        bidType: item.bidType,
                                        backgroundColor: "rgb(0,128,0)",  // Green
                                        borderColor: "rgb(0,128,0)"
                                    });
                                }
                                else if (item.status == 'Closed-Draft' || item.status == 'Draft') {
                                    data.push({
                                        id: item.id,
                                        editable: false,
                                        title: item.name,
                                        name: item.name,
                                        start: item.internalClosingDate,
                                        end: item.internalClosingDate,
                                        type: 'Bid',
                                        status: item.status,
                                        internalClosingDate: item.internalClosingDate,
                                        customerClosingDate: item.customerClosingDate,
                                        bidType: item.bidType,
                                        backgroundColor: "rgb(255,0,0)", // Red
                                        borderColor: "rgb(255,0,0)"
                                    });
                                }
                                else {
                                    data.push({
                                        id: item.id,
                                        editable: false,
                                        title: item.name,
                                        name: item.name,
                                        start: item.internalClosingDate,
                                        end: item.internalClosingDate,
                                        type: 'Bid',
                                        status: item.status,
                                        internalClosingDate: item.internalClosingDate,
                                        customerClosingDate: item.customerClosingDate,
                                        bidType: item.bidType,
                                        backgroundColor: "rgb(255,140,0)",  // Orange
                                        borderColor: "rgb(255,140,0)"
                                    });
                                }
                            }
                            else {
                                data.push({
                                    id: item.id,
                                    editable: false,
                                    title: item.name,
                                    name: item.name,
                                    start: item.internalClosingDate,
                                    end: item.internalClosingDate,
                                    type: 'Bid',
                                    status: item.status,
                                    internalClosingDate: item.internalClosingDate,
                                    customerClosingDate: item.customerClosingDate,
                                    bidType: item.bidType,
                                    backgroundColor: "rgb(0,128,0)",  // Green
                                    borderColor: "rgb(0,128,0)"
                                });
                            }
                        }

                        else if (item.type == 'Task') {
                            data.push({
                                id: item.id,
                                editable: false,
                                title: item.name,
                                start: item.startDate,
                                end: item.startDate,
                                type: 'Task',
                                backgroundColor: "rgb(0,0,255)", // blue
                                borderColor: "rgb(0,0,255)"
                            });
                        }

                        else if (item.type == 'Event') {
                            data.push({
                                id: item.id,
                                editable: false,
                                title: item.name,
                                name: item.name,
                                start: item.startDate,
                                end: item.endDate,
                                type: 'Event',
                                backgroundColor: "rgb(0,0,128)", // navy blue
                                borderColor: "rgb(0,0,128)"
                            });
                        }

                    }
                    this.allEvents = data;
                }
                this.initialiseFullCalendar();
            })
            .catch(error => {
                console.log(' Error Occured ', error)
            })
            .finally(() => {
                //this.initialiseFullCalendar();
            })
    }

    closeModal() {
        this.selectedEvent = undefined;
        this.showModal = false;
    }
}