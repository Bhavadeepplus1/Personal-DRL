({
    afterScriptsLoaded: function(cmp,evt,helper){
        cmp.set('v.loaded', true);
        helper.fetchCalenderEvents(cmp);
        helper.getAcc(cmp,evt,helper);
    },
    
    handleClick : function(component, event, helper){ 
        var d = new Date();
        var month = d.getMonth()+1;
        var day = d.getDate();
        var currentDate = d.getFullYear() + '/' +
            (month<10 ? '0' : '') + month + '/' +
            (day<10 ? '0' : '') + day;
        
        var self = this;
        var buttonstate = component.get("v.buttonstate");
        component.set("v.buttonstate",!buttonstate);
        console.log('Object list--->' + component.get("v.Objectlist"));
        //var events = component.get("v.Objectlist");
        if(!buttonstate){
            console.log('List View');
            $("#listcalendar").show();
            $("#calendarEvent").hide();
            $('#listcalendar').fullCalendar({
                defaultView: 'listWeek',
                listDayFormat : false,
                defaultDate: currentDate,
                navLinks: true, // can click day/week names to navigate views
                selectable : true,
                selectMirror: true,
                disableResizing:true,
                editable: false,
                eventLimit: true,
                dragScroll : true,
                droppable: true,
                weekNumbers : true,
                events : component.get("v.Objectlist"),
                icon: event.icon,
                buttonText: {
                today:    '   Today   ',
                month:    'Month',
                week:     'Week',
                day : 'Day'
            },
            eventRender: function (event, eventElement) {
                    
                  
              if (event.icon) {
                eventElement.find(".fc-list-item-title").prepend("<img src='" + event.icon +"' style='max-width: 30px;'>" + '&nbsp;');
                //console.log(eventElement.find(".fc-list-item-marker").prepend("<img src='" + event.icon +"' style='width:20px;height:20px;'>")); 
                 
                 eventElement.click(function () {
                     var editRecordEvent = $A.get("e.force:navigateToSObject");
                 editRecordEvent.setParams({
                    "recordId": event.id
                });
                editRecordEvent.fire();  
                     
                   // alert('Event: ' + event.id);
                    $(this).attr("id", event.id);
                    $(this).attr("title", event.title);
                    //eventElement.find(".fc-list-item-title").attr("href ' " , event.id );
                    });
                
                     /* var createRecordEvent = $A.get("e.force:createRecord");
                      createRecordEvent.setParams({
                      "entityApiName": "Event"
                    });
                    createRecordEvent.fire(); */
                  
                 
                
                  
              }
                
                      
                  
            /* if(event.icon){ 
                    console.log('event.icon--->'+event.icon);
                    element.find(".fc-title").append("<img src='/resource/1649244932000/AccountCalender_Auction_Icon' alt='' style='width:20px;height:20px;'>");
                    //this.element.querySelector('.fc-title').innerHTML = "<img src="+event.icon+" alt='' style='width:20px;height:20px;'>";
                    // alert(event);
                    //console.log(element.find(".fc-title").prepend("<i class='fa fa-"+event.icon+"'></i>"));
                    //element.find("title").prepend("<i class='fa fa-"+event.icon+"'></i>");
                    //element.find(".fc-title").html(function () { return $(this).html().replace("$ICON", "<img src='/resource/1649082696000/HammerIcon' alt='' style='width:20px;height:20px;background:green;'>")});
                   //element.find(".fc-title").html(function () { return $(this).html().replace("$ICON", "<img src='/resource/1649244932000/AccountCalender_Auction_Icon' alt='' style='width:20px;height:20px;'>")});
                   element.find(".fc-title").html(function () { 
                       console.log('event dot');
                   var btn = $(".fc-title");
                   btn.prepend("<img src="+event.icon+" alt='' style='width:20px;height:20px;'> ")
                   //console.log('Icons--->'+ btn);
                   //return $(this).html().replace("$ICON", "<img src="+event.icon+" alt='' style='width:20px;height:20px;'>")});
              
                   });                  
                        
                    //opp icon - /resource/1649245142000/AccountCalender_Opportunity_Icon     
                   // element.find(".fc-title").html(function () { return $(this).html().replace("$ICON", '<i class="fa fa-cloud"></i>')});
                    
                }*/ 
            },
                  
                    
            
            });
            //helper.formatFullCalendarData(component, events);
            //helper.fetchCalenderEvents(component);
            //console.log('event--->'+component.get("v.Objectlist").id);
        }
        else{
            $("#calendarEvent").show();
            $("#listcalendar").hide();  
            helper.fetchCalenderEvents(component);
   
            
           
        }
        
    },
    addNewEventToSF :function(date, jsEvent, view) {
        var datetime;
        //   var datelist = date.format().toString().split('-');
        
        //var datetime = new Date(datelist[0],parseInt(datelist[1])-1,parseInt(datelist[2])+1,0,0,0,0);
        
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Event",
            "defaultFieldValues": {
                'StartDateTime' :  datetime
                
            }
        });
        createRecordEvent.fire();
    },
    handleClickAll:function (component,event,helper){
        var datetime;
        //   var datelist = date.format().toString().split('-');
        
        //var datetime = new Date(datelist[0],parseInt(datelist[1])-1,parseInt(datelist[2])+1,0,0,0,0);
        
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Task",
            "defaultFieldValues": {
                'StartDateTime' :  datetime
                
            }
        });
        createRecordEvent.fire();
        
    },
    openModel: function(component, event, helper) {
        
        var recId=component.get("v.recordId");
        var accId=component.get("v.accObj.Id");
        component.set("v.selectedRecIdForAlert",accId);
        component.set("v.accObj", recId);
        component.set("v.isModalOpen", true);
       //helper.loadDataToCalendar(component);
    },
    openLegendsModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isLegendsModalOpen", true);
      
    },
    closeLegendsModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isLegendsModalOpen", false);
      
    },
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    }
})