({
    afterScriptsLoaded: function(cmp,evt,helper){
        cmp.set('v.loaded', true);
        helper.fetchCalenderEvents(cmp);
     //   helper.getAcc(cmp,evt,helper);
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
            $("#calendaraborted").hide();
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
               
              }

            },
                  
                    
            
            });
            
        }
        else{
            $("#calendaraborted").show();
            $("#listcalendar").hide();  
            helper.fetchCalenderEvents(component);
        }
        
    },
    addNewEventToSF :function(date, jsEvent, view) {
        var datetime;
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