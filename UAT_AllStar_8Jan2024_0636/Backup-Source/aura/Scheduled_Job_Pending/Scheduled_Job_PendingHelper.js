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
        
        $('#calendarpending').css('font-size', '1.2em');
        $('#calendarpending').fullCalendar({
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
                 
               element.find(".fc-title").html(function () { 
                   var btn = $(this);
    btn.prepend("<img src="+event.icon+" alt='' style='width:20px;height:20px;'> ");
                   //return $(this).html().prepend("<img src="+event.icon+" alt='' style='width:20px;height:20px;'>")});
              
                   });
                
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
          /*  eventClick: function(event, jsEvent, view) {
              
                console.log('in event click-->'+event.id);
                var editRecordEvent = $A.get("e.force:navigateToSObject");
                editRecordEvent.setParams({
                    "recordId": event.id
                });
                editRecordEvent.fire();
            //}
            },*/
          /*  dayClick :function(date, jsEvent, view) {
              
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
            },*/
            
            eventMouseover : function(event, jsEvent, view) {
                console.log('in event eventMouseover-->'+event.id);
                console.log('eventMouseoverHandler starts');
                
                console.log('Status: ' + event.status);
                var startdate = event.start != null ? $A.localizationService.formatDateTime(event.start): null;
                var enddate = event.enddate != null ? ($A.localizationService.formatDateTime(event.enddate)): null;//+" 20:00:00";
                var startdateTime= event.start != null ? ($A.localizationService.formatDateTime(event.start)):null;
                var enddateTime= event.enddate != null ? ($A.localizationService.formatDateTime(event.enddate)):null;
                let data;
                
                if (event.status__c == 'Processing') {
                    //  alert('Completed')
                    //var apx=event.ApexClass.name;
                    //alert(apx);
                    data = '<b>Name: </b>' + event.title + '<br/>' + '<b>Job Description: </b>' + event.jobdescription + '<br/>' + '<b>Start Date Time: </b>' + event.createddate + '<br/>' + '<b>End Date Time: </b>' + event.completeddate + '<br/>' + '<b> Total Job Batches: </b>' + event.jobtotalbatches + '<br/>'+ '<b>Total Job Records: </b>' + event.totaljobitems + '<br/>' + '<b>Job Records Processed: </b>' + event.jobitemsprocessed + '<br/>' + '<b>Status: </b>' + event.status + '<br/>' + '<b>Job Submitted By: </b>' + event.jobsumbittedby + '<br/>' + '<b>Job Source: </b>' + event.jobsource + '<br/>'+ '<b>Job Destination: </b>' + event.jobdestination + '<br/>'+ '<b>Job Used For: </b>' + event.jobusedfor + '<br/> '+ '<b>Job Duration: </b>' + event.jobduration + '<br/>';
                }
                
                else{
                    //  alert('None')
                    data = '<b>Name: </b>' + event.title + '<br/>' + '<b>Job Description: </b>' + event.jobdescription + '<br/>' + '<b>Start Date Time: </b>' + event.createddate + '<br/>' + '<b>End Date Time: </b>' + event.completeddate + '<br/>' + '<b> Total Job Batches: </b>' + event.jobtotalbatches + '<br/>'+ '<b>Total Job Records: </b>' + event.totaljobitems + '<br/>' + '<b>Job Records Processed: </b>' + event.jobitemsprocessed + '<br/>' + '<b>Status: </b>' + event.status + '<br/>' + '<b>Job Submitted By: </b>' + event.jobsumbittedby + '<br/>' + '<b>Job Source: </b>' + event.jobsource + '<br/>'+ '<b>Job Destination: </b>' + event.jobdestination + '<br/>'+ '<b>Job Used For: </b>' + event.jobusedfor + '<br/> '+ '<b>Job Duration: </b>' + event.jobduration + '<br/>';
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
            var startdate = events[i].CreatedDate != null ? $A.localizationService.formatDateTime(events[i].CreatedDate__c):null;
            var enddate = events[i].CompletedDate != null ? $A.localizationService.formatDateTime(events[i].CompletedDate__c):null;
            var startDateTime = events[i].CreatedDate != null ? $A.localizationService.formatDateTime(events[i].CreatedDate__c):null;
            var endDateTime = events[i].CompletedDate != null ? $A.localizationService.formatDateTime(events[i].CompletedDate__c):null;
          
            console.log('test-->'+events[i].Status__c)
           if (events[i].Status__c == 'Processing') {
                    console.log('inside Event');
                     console.log('start date time-->'+events[i].CreatedDate);
                    //nextDayThreshold: '20:00:00',
                    josnDataArray.push({
                         title:events[i].Job_Name__c,
                        'allDay':false,
                        'backgroundColor': "rgb(255,165,0)",// navy blue
                        'id':events[i].id,
                        icon: '/resource/1653551355000/AccountCalender_E',
                        'borderColor': "rgb(255,165,0)",
                        type:events[i].MethodName,
                        status:events[i].Status__c,
                        totaljobitems:events[i].TotalJobItems__c,
                        jobitemsprocessed:events[i].JobItemsProcessed__c,
                        createddate:events[i].Job_Start_Date__c,
                        completeddate:'NA',
                        jobdescription:events[i].Job_Description__c,
                        jobsumbittedby:events[i].Job_Run_By__r.Name,
                        jobsource:events[i].Job_Source__c,
						jobdestination:events[i].Job_Destination__c,
						jobusedfor:events[i].Job_Used_For__c,
                        jobtotalbatches:events[i].TotalJobBatches__c,
                        jobduration:'NA',
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
                   //Aborted==> The status of the job
              
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
        var action=component.get("c.getApeSyncObjPending");
        action.setParams({ 
            //"accountId": component.get("v.recordId") 
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
    /*editEvent : function(component,eventid,eventdate){
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
        
    }*/
})