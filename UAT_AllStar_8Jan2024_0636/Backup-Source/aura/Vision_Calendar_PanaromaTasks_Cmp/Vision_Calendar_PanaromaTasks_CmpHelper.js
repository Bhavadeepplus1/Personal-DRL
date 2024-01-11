({
    loadDataToCalendar :function(component,data){  
       // alert('loadDataToCalendar');
        //Find Current date for default date
        var d = new Date();
        var month = d.getMonth()+1;
        var day = d.getDate();
        var currentDate = d.getFullYear() + '/' +
            (month<10 ? '0' : '') + month + '/' +
            (day<10 ? '0' : '') + day;
        
        var self = this;
        
        $('#calendarPanaroma').css('font-size', '1.2em');
        $('#calendarPanaroma').fullCalendar({
            customButtons: {
            },
            buttonText: {
                today:    '   Today  ',
                month:    'Month',
                week:     'Week',
                day : 'Day'
            },
            header: {
                left: 'prev,next today',
                center: 'title ',
                right: 'add_task  add_alert  add_notification add_legends month,basicWeek,basicDay'
            },
            selectable : true,
            defaultDate: currentDate,
            editable: true,
            eventLimit: true,
            events:data,
            dragScroll : true,
            droppable: true,
            weekNumbers : true,
            displayEventTime : false ,
            //businessHours: true, // display business hours
            displayEventEnd: true,
            firstDay:1,
            borderColor :'#ccdfff',
            eventRender: function (event, element) {
               

                if(event.icon){  
                    // alert(event);
                    //console.log(element.find(".fc-title").prepend("<i class='fa fa-"+event.icon+"'></i>"));
                    //element.find("title").prepend("<i class='fa fa-"+event.icon+"'></i>");
                    //element.find(".fc-title").html(function () { return $(this).html().replace("$ICON", "<img src='/resource/1649082696000/HammerIcon' alt='' style='width:20px;height:20px;background:green;'>")});
                   //element.find(".fc-title").html(function () { return $(this).html().replace("$ICON", "<img src='/resource/1649244932000/AccountCalender_Auction_Icon' alt='' style='width:20px;height:20px;'>")});
               element.find(".fc-title").html(function () { 
                   var btn = $(this);
    btn.prepend("<img src="+event.icon+" alt='' style='width:20px;height:20px;'> ");
                   //return $(this).html().prepend("<img src="+event.icon+" alt='' style='width:20px;height:20px;'>")});
              
                   });
                    //opp icon - /resource/1649245142000/AccountCalender_Opportunity_Icon     
                    //element.find(".fc-title").html(function () { return $(this).html().replace("$ICON", '<i class="fa fa-cloud"></i>')});
                    
                }
                
            },
            eventDrop: function(event, delta, revertFunc) {
                
                alert(event.title + " was dropped on " + event.start.format());
                
                if (!confirm("Are you sure about this change?")) {
                    revertFunc();
                }
                else{
                    var eventid = event.id;
                    var eventdate = event.start.format();
                    self.editEvent(component,eventid,eventdate);
                }
                
            },
            eventClick: function(event, jsEvent, view) {
                /*if(event.object){
                 var pageReference = {
          "type": "standard__navItemPage",
    "attributes": {
        "apiName": "PanoramaTasks" // replace with the API name of your custom tab   
    }
        }; 
                     var navService = component.find("navService");
                    var pageReference = {
            type: 'standard__navItemPage',
            attributes: {
                recordId: component.get("v.recordId"),
                objectApiName: 'Account',
                actionName: 'detail'
            }
                }
                    navService.navigate(pageReference);
                    }
                else{
                */    
                console.log('in event click-->'+event.id);
                var editRecordEvent = $A.get("e.force:navigateToSObject");
                editRecordEvent.setParams({
                    "recordId": event.id
                });
                editRecordEvent.fire();
            //}
            },
            dayClick :function(date, jsEvent, view) {
               // alert('day clicked');
                //var datetime;
                var datelist = date.format().toString().split('-');
                
                var datetime = new Date(datelist[0],parseInt(datelist[1])-1,parseInt(datelist[2])+1,0,0,0,0);
                console.log('datelist'+datelist);
                console.log('datetime'+datetime);
                var formattedDate = datetime.toDateString();
                var createRecordEvent = $A.get("e.force:createRecord");
                createRecordEvent.setParams({
                    "entityApiName": "Event",
                    "defaultFieldValues": {
                        'StartDateTime' :  formattedDate
                        
                    }
                });
                createRecordEvent.fire();
            },
            
            eventMouseover : function(event, jsEvent, view) {
                console.log('in event eventMouseover-->'+event.id);
                console.log('eventMouseoverHandler starts');
                console.log('type: ' + event.type);
                console.log('Name: ' + event.title);
                console.log('status: ' + event.status);
                var startdate = event.start != null ? $A.localizationService.formatDateTime(event.start): null;
                var enddate = event.enddate != null ? ($A.localizationService.formatDateTime(event.enddate)): null;//+" 20:00:00";
                var startdateTime= event.start != null ? ($A.localizationService.formatDateTime(event.start)):null;
                var enddateTime= event.enddate != null ? ($A.localizationService.formatDateTime(event.enddate)):null;
                let data;
                if (event.type == 'Bid') {
            		data = '<b>Type: </b>' + event.type + '<br/>' + '<b>Name: </b>' + event.title + '<br/>' + '<b>Status: </b>' + event.status + '<br/>' + '<b>Internal Target Date: </b>' + startdate + '<br/>' + '<b>Customer Bid Deadline Date: </b>' + enddate + '<br/>';
        		}
                else if (event.type == 'Event') {
                    
            		data = '<b>Type: </b>' + event.type + '<br/>' + '<b>Name: </b>' + event.title + '<br/>' + '<b>Start Date: </b>' + startdateTime + '<br/>' + '<b>End Date: </b>' + enddateTime + '<br/>';
        		}
                else if(event.type == 'Opportunity'){
                    console.log('START Time: ' + $A.localizationService.formatDateTime(startdate));
                console.log('END DATE: ' +  $A.localizationService.formatDateTime(enddate));
                    data = '<b>Type: </b>' + event.type + '<br/>' + '<b>Name: </b>' + event.title + '<br/>' + '<b>Status: </b>' + event.status + '<br/>' + '<b>Internal Target Date: </b>' + startdate + '<br/>' + '<b>Customer Bid Deadline Date: </b>' + enddate + '<br/>';
                }
                else if(event.type == 'Panorama Task'){
                    data = '<b>Type: </b>' + event.type + '<br/>' + '<b>Name: </b>' + event.title + '<br/>'  + '<b>Status: </b>' + event.status + '<br/>' + '<b>Internal Target Date: </b>' + startdate + '<br/>'+'<b>Plan Contract Effective Date: </b>' + enddate + '<br/>';
                }
                else if(event.type == 'Task'){
                    data = '<b>Type: </b>' + event.type + '<br/>' + '<b>Name: </b>' + event.title +  '<br/>'  + '<b>Status: </b>' + event.status + '<br/>' + '<b>Activity Date: </b>' + startdate + '<br/>';
                }
                else{
                    data = '<b>Name: </b>' + event.title + '<br/>';
                }
                console.log('dataa->'+data)
                var tooltip = '<div class="tooltipevent slds-popover slds-popover_tooltip" role="tooltip" id="help" style="position:absolute;top:-4px;left:35px">  <div class="slds-popover__body">' + data + '</div> </div>';
                var $tooltip = $(tooltip).appendTo('body');
                $(this).mouseover(function (e) {
                    $(this).css('z-index', 10000);
                    $tooltip.fadeIn('500');
                    $tooltip.fadeTo('10', 1.9);
                }).mousemove(function (e) {
                    $tooltip.css('top', e.pageY + 10);
                    $tooltip.css('left', e.pageX + 20);
                });
            },
              eventMouseout : function(event, jsEvent, view) {
                  $(this).css('z-index', 8);
        		$('.tooltipevent').remove();
              }
            
        });
         component.set('v.loaded', false);
         //component.set("v.isModalOpen",true);  
    },
    
    
    formatFullCalendarData : function(component,events) {
        
        var josnDataArray = [];
        const currentDate = new Date().toISOString().split('T')[0];
        var today = new Date();
       var currentDatePlusFive = new Date();
		currentDatePlusFive.setDate(today.getDate()+5);
        var currentDatePlusFiveISO = currentDatePlusFive.toISOString().split('T')[0];
         var currentDateMinusFive = new Date();
		currentDateMinusFive.setDate(today.getDate()-5);
        var currentDateMinusFiveISO = currentDateMinusFive.toISOString().split('T')[0];
        console.log('currentDate: ' + currentDate);
         console.log('currentDatePlusFive-->'+currentDatePlusFiveISO);
         console.log('currentDateMinusFive-->'+currentDateMinusFiveISO);
        console.log('component: ' + component);
        console.log('events: ' + JSON.stringify(events));
        for(var i = 0;i < events.length;i++){
            var startdate = events[i].startDate != null ? $A.localizationService.formatDateTime(events[i].startDate):null;
            var enddate = events[i].endDate != null ? $A.localizationService.formatDateTime(events[i].endDate):null;
            var startDateTime = events[i].startDateTime != null ? $A.localizationService.formatDateTime(events[i].startDateTime):null;
            var endDateTime = events[i].endDateTime != null ? $A.localizationService.formatDateTime(events[i].endDateTime):null;
            //var enddate = ($A.localizationService.formatDate(events[i].endDate))+" 20:00:00";
      
            //var ed = ($("enddate").val())+" 20:00:00";
     
            console.log('test-->'+events[i].type)
            if (events[i].type == 'Opportunity') {
                  if (events[i].status == 'Closed Won' || events[i].status == 'Closed Lost' || events[i].status == 'Sent to BRIGHT') {
                        josnDataArray.push({
                             title:events[i].name,
                            'start':startdate,
                            'end':startdate,
                            'enddate':enddate,
                            'backgroundColor': "rgb(0,128,0)",  // Green
                            //icon: 'fa-check-circle',
                            icon: '/resource/1653400974000/AccountCalender_O',
                            //'/resource/1649397787000/AccountCalender_O',
                            'id':events[i].id,
                            'borderColor':"rgb(0,128,0)",
                            type:events[i].type,
                            status:events[i].status
                        });
                        
                    }
                else if (currentDatePlusFiveISO <= events[i].internalClosingDate) {
                    if (events[i].status == 'Opportunity in progress') {
                        console.log('enddate-->'+enddate)
                        josnDataArray.push({
                            title:events[i].name,
                            'start':startdate,
                            'end':startdate,
                            'enddate':enddate,
                            'backgroundColor': "rgb(255,140,0)", // orange
                            'id':events[i].id,
                            icon: '/resource/1653400974000/AccountCalender_O',
                            'borderColor':"rgb(255,140,0)",
                            type:events[i].type,
                            status:events[i].status
                        });
                    }
                   
                }
                else if (events[i].internalClosingDate < currentDatePlusFiveISO) {
                    if (events[i].status == 'Opportunity in progress') {
                        console.log('enddate-->'+enddate)
                        josnDataArray.push({
                            title:events[i].name,
                            'start':startdate,
                            'end':startdate,
                            'enddate':enddate,
                            'backgroundColor': "rgb(255,0,0)", // red
                            'id':events[i].id,
                            icon: '/resource/1653400974000/AccountCalender_O',
                            'borderColor':"rgb(255,0,0)",
                            type:events[i].type,
                            status:events[i].status
                        });
                    }
                   
                }
                
            }
            else if (events[i].type == 'Bid') {
                /* var icon1 = component.find("icon1"); 
                console.log('icon-->'+icon1.get("v.iconName"));
                icon1.set("v.iconName","utility:activity"); */
                let customerUpdate1 = "Customer" + "'s " + 'Update';
                let customerUpdate2 = "Customner" + "'s " + 'Update';
                if (events[i].status == customerUpdate1 || events[i].status == customerUpdate2  || events[i].status == 'Vistex Update'||events[i].status == 'Closed') {
                        console.log('---1----')
                        josnDataArray.push({
                            title:events[i].name,
                            'start':startdate,
                            'end':startdate,
                            'enddate':enddate,
                            'backgroundColor': "rgb(0,128,0)",//green
                            'id':events[i].id,
                            'borderColor':"rgb(0,128,0)",
                            icon: '/resource/1649397787000/AccountCalender_B',
                            type:events[i].type,
                            status:events[i].status
                        });
                    } 
                else if (events[i].status == 'Draft' || events[i].status == 'On Hold'){
                    console.log('---2----')
                        josnDataArray.push({
                            title:events[i].name,
                            'start':startdate,
                            'end':startdate,
                            'enddate':enddate,
                            'backgroundColor': "rgb(255,0,0)",//red
                            'id':events[i].id,
                            'borderColor':"rgb(255,0,0)",
                            icon: '/resource/1649397787000/AccountCalender_B',
                            type:events[i].type,
                            status:events[i].status
                        });
                    }
                else if (events[i].status == 'Closed-Draft'||events[i].status == 'Supply Chain Rejected'||events[i].status == 'Marketing Rejected'||events[i].status == 'Marketing Lead Rejected'
                       ||events[i].status == 'Marketing Head Rejected'||events[i].status == 'Business Head Rejected'||events[i].status == 'Finance Rejected'||events[i].status == 'Sr Director or VP Finance Rejected'
                       ||events[i].status == 'Customer Service Rejected'||events[i].status == 'Contracts Rejected'||events[i].status == 'Customer Rejected'||events[i].status == 'Vistex Update Rejected'){
                    console.log('I am in---4----')   
                    josnDataArray.push({
                            title:events[i].name,
                            'start':startdate,
                            'end':startdate,
                            'enddate':enddate,
                            'backgroundColor': "rgb(128,128,128)",//gray
                            'id':events[i].id,
                            'borderColor':"rgb(128,128,128)",
                            icon: '/resource/1649397787000/AccountCalender_B',
                            type:events[i].type,
                            status:events[i].status
                        });
                    }
                 else if( currentDatePlusFiveISO <= events[i].internalClosingDate){
                    if(events[i].status == 'Supply Chain' || events[i].status == 'Marketing'|| events[i].status == 'SCM & Marketing'|| events[i].status == 'Marketing Lead'||events[i].status == 'Marketing Head'|| events[i].status == 'Business Head'
                       || events[i].status == 'Finance'|| events[i].status == 'Sr Director or VP Finance'||events[i].status == 'Customer Service'||events[i].status == 'Customer Service Update'||events[i].status == 'Vistex Customer Code Update'
                       ||events[i].status == 'Contracts'){
                        console.log('---4----')
                        josnDataArray.push({
                            title:events[i].name,
                            'start':startdate,
                            'end':startdate,
                            'enddate':enddate,
                            'backgroundColor': "rgb(255,140,0)",//orange
                            'id':events[i].id,
                            'borderColor':"rgb(255,140,0)",
                            icon: '/resource/1649397787000/AccountCalender_B',
                            type:events[i].type,
                            status:events[i].status
                        });
                    }
                }
                 else if(events[i].internalClosingDate < currentDatePlusFiveISO){
                    console.log('---3----')
                    if (events[i].status == 'Supply Chain' || events[i].status == 'Marketing'|| events[i].status == 'SCM & Marketing'|| events[i].status == 'Marketing Lead'||events[i].status == 'Marketing Head'|| events[i].status == 'Business Head'
                       || events[i].status == 'Finance'|| events[i].status == 'Sr Director or VP Finance'||events[i].status == 'Customer Service'||events[i].status == 'Customer Service Update'||events[i].status == 'Vistex Customer Code Update'
                       ||events[i].status == 'Contracts'){
                        josnDataArray.push({
                            title:events[i].name,
                            'start':startdate,
                            'end':startdate,
                            'enddate':enddate,
                            'backgroundColor': "rgb(255,0,0)",//red
                            'id':events[i].id,
                            'borderColor':"rgb(255,0,0)",
                            icon: '/resource/1649397787000/AccountCalender_B',
                            type:events[i].type,
                            status:events[i].status
                        });
                    }
                }
              
            }
                else if (events[i].type == 'Event') {
                    console.log('inside Event');
                     console.log('start date time-->'+events[i].startDateTime);
                    //nextDayThreshold: '20:00:00',
                    josnDataArray.push({
                         title:events[i].name,
                        'allDay':false,
                        'backgroundColor': "rgb(0,0,128)",// navy blue
                        'id':events[i].id,
                        icon: '/resource/1653551355000/AccountCalender_E',
                        'borderColor': "rgb(0,0,128)",
                        type:events[i].type,
                        status:events[i].status,
                        //'startDateTime':events[i].startDateTime,
                         //'endDateTime':events[i].endDateTime,
                        'start':startDateTime,
                        'end':startDateTime,
                        'enddate':endDateTime,
                        ////'displayEventTime':false,
                        //'nextDayThreshold': '00:00',
                        // //'icon':"insert_tag_field"
                    });
                   
                    console.log('startdate--->'+startdate);
                    console.log('enddate--->'+enddate);
                }
                    else if (events[i].type == 'Task') {
                        josnDataArray.push({
                           title:events[i].name,
                            'start':startdate,
                            'end':startdate,
                            'enddate':enddate,
                            'backgroundColor': "rgb(0,0,255)",// blue
                            'id':events[i].id,
                             icon:'/resource/1653481576000/AccountCalender_T',
                            'borderColor': "rgb(0,0,255)",
                            //'icon':"insert_tag_field"
                            type:events[i].type,
                            status:events[i].status
                            
                        });
                    }
            			 else if (events[i].type == 'Panorama Task') {
                            if(events[i].status == 'Sent to BRIGHT'){
                                 josnDataArray.push({
                                         title:events[i].name,
                                        'start':startdate,
                                        'end':startdate,
                                     	'enddate':enddate,
                                        'backgroundColor': "rgb(0,128,0)",  // Green
                                        'id':events[i].id,
                                         icon:'/resource/1653551407000/AccountCalender_P',
                                        'borderColor': "rgb(0,128,0)",  // Green
                                     	type:events[i].type,
                                     status:events[i].status
                                        });
                             }
                                else if (events[i].status == 'New'){
                                    josnDataArray.push({
                                         title:events[i].name,
                                        'start':startdate,
                                        'end':startdate,
                                        'enddate':enddate,
                                        'backgroundColor': "rgb(255,0,0)",//red
                                        'id':events[i].id,
                                         icon:'/resource/1653551407000/AccountCalender_P',
                                        'borderColor': "rgb(255,0,0)",
                                        type:events[i].type,
                                        status:events[i].status,
                                        object:'Panorama',
                                        });
                             }
                          else if(currentDatePlusFiveISO <= events[i].internalClosingDate){
                              if(events[i].status == 'Sent to OPPORTUNITY'){
                                 josnDataArray.push({
                                         title:events[i].name,
                                        'start':startdate,
                                        'end':startdate,
                                     	'enddate':enddate,
                                        'backgroundColor': "rgb(255,140,0)",  // Orange
                                        'id':events[i].id,
                                         icon:'/resource/1653551407000/AccountCalender_P',
                                        'borderColor': "rgb(255,140,0)",  // Orange
                                    	 type:events[i].type,
                                     status:events[i].status
                                        });
                             }
                          }
                          else if(events[i].internalClosingDate < currentDatePlusFiveISO ){
                              if(events[i].status == 'Sent to OPPORTUNITY'){
                                 josnDataArray.push({
                                         title:events[i].name,
                                        'start':startdate,
                                        'end':startdate,
                                     	'enddate':enddate,
                                        'backgroundColor': "rgb(255,0,0)",  // red
                                        'id':events[i].id,
                                         icon:'/resource/1653551407000/AccountCalender_P',
                                        'borderColor': "rgb(255,0,0)",  // red
                                    	 type:events[i].type,
                                     status:events[i].status
                                        });
                             }
                          }
                             
                            
                    	}
            				/*	else if (events[i].type == 'Alert' || events[i].type == 'Notification') {
                                       //  alert('in Alert ')
                                        josnDataArray.push({
                                           title:events[i].name,
                                            'start':startdate,
                                            'end':startdate,
                                            'backgroundColor': "rgb(204,204,0)",// lite greenish yellow
                                            'id':events[i].id,
                                            icon:'/resource/1649342402000/AccountCalender_A',
                                            'borderColor': "rgb(204,204,0)",
                                            });
                    			}
                                    else{
                                        var startdate = $A.localizationService.formatDate(events[i].startDate);
                                        josnDataArray.push({
                                            title:events[i].name,
                                            'start':startdate,
                                            'end':startdate,
                                            'backgroundColor': "rgb(255,0,0)",
                                            'id':events[i].id,
                                            icon: 'fa-check-circle'
                                        }); 
                                }*/
            /* var startdate = $A.localizationService.formatDate(events[i].startDate);
            var enddate = $A.localizationService.formatDate(events[i].EndDateTime);
            josnDataArray.push({
                'title':events[i].name,
                'start':startdate,
                'end':startdate,
                'backgroundColor': "rgb(255,0,0)",
                'id':events[i].id
            });*/
        }
        
        
        return josnDataArray;
    },
    
    fetchCalenderEvents : function(component,event, element, view) {
        //alert('fetchCalenderEvents');
        //getAllEvents
        console.log('Before Cmp--->'+ component);
        console.log('Before Evnt--->'+ event);
        console.log('Before Elmnt---->'+ element);
        console.log('Before View---->'+ view);
        component.set("v.isModalOpen", false);
        var action=component.get("c.fetchOpportunitiesAndBids");
        action.setParams({ "accountId": component.get("v.recordId"),
                           "Comparision": "panorama"
                         });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data= response.getReturnValue();
                console.log('res-->'+JSON.stringify(data))
                var josnArr = this.formatFullCalendarData(component,response.getReturnValue());
                console.log('josnArr--->'+ JSON.stringify(josnArr))
                this.loadDataToCalendar(component,josnArr);
                component.set("v.Objectlist",josnArr);
                //component.set("v.alertedItemType",'gcpItem');
                
            } else if (state === "ERROR") {
                
            }
        });
        console.log('After Cmp--->'+ component);
        console.log('After Evnt--->'+ event);
        console.log('After Elmnt---->'+ element);
        console.log('After View---->'+ view);
        
        $A.enqueueAction(action);
        
    }, 
    
    getAcc : function(cmp, evt, helper){
        var action = cmp.get("c.getAccObj");
        action.setParams({accId:cmp.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var accObj = response.getReturnValue();            
            	cmp.set('v.accObj',accObj);
            }
            else{
                console.log('error while fetching alert : '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
    editEvent : function(component,eventid,eventdate){
        var action=component.get("c.updateEvent");
        
        action.setParams({ eventid : eventid ,
                          eventdate : eventdate});
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                
            } else if (state === "ERROR") {
                
            }
        });
        
        $A.enqueueAction(action);
        
    }
})