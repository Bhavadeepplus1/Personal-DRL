/**
* @Description       : This class contains to run scheduledjob run at every 5 min.
* @Author            : Ramakrishna Y
* @Created on        : 27-09-2022
* @last modified by  : Ramakrishna Y
**/
global class ScheduleJobInsert implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        // Implement any logic to be scheduled
       
        // We now call the batch class to be scheduled
        InsertScheduleJob b = new InsertScheduleJob ();
       
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(b);
    }
   
}