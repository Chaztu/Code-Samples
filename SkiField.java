import java.util.*;



public class SkiField {
	
    static Queue<Integer> waitingQueue = new LinkedList<Integer>();                //create Waiting Queue
    static Queue<Integer> liftQueue = new LinkedList<Integer>();                   //create Lift Queue
    static boolean active = true;

	public static void main(String[] args) {
		
		MyJFrame gui = new MyJFrame("My Window", 400, 400, 600, 600);
			
		int NUMBER_OF_SKIERS = 30;                                                 // Skiers on skifield
        int LIFT_CAPACITY = 10;                                                    // Number of seats on the lift
        int DELAY_PROBABILITY = 5;                                                 // Chance of lift stalling (in percentages)
        int DELAY_TIME = 1000;
        
        
        for(int i = 1; i <= NUMBER_OF_SKIERS; i++){
            waitingQueue.add(i);                                                // fill Waiting Queue
        }
        
        for(int i = 0; i < LIFT_CAPACITY; i++){
            liftQueue.add(0);                                                     //fill Lift Queue
        }
        
        while(true){
        	while(active){
            
            MyJPanel.insertText("On Lift (" + SkiField.countLiftQueue() + ") : [");                          // Print people in lift
            for (Integer element : liftQueue) {
                if(element == 0)
                    MyJPanel.insertText("EMPTY ");
                else
                    MyJPanel.insertText(element.toString() + " ");
            }
            MyJPanel.insertText("]\n");
            
            MyJPanel.insertText("In Queue (" + waitingQueue.size() + ") : [");                       // Print people in the waiting queue
            for (Integer element : waitingQueue) {
                MyJPanel.insertText(element.toString() + " ");
            }
            MyJPanel.insertText("]\n");
            
            MyJPanel.insertText("\n");
            
            
            try{
                Thread.sleep(DELAY_TIME);                                              // constant speed of the lift - the lower the faster
            } catch(InterruptedException e){
                e.printStackTrace();
            }
            
            Skier skier = new Skier(liftQueue.remove());                          //remove front of lift queue and start() skier
            if(skier.getID() > 0)
                skier.start();
            
            if(waitingQueue.size() > 0){
                liftQueue.add(waitingQueue.remove());                             //append front of waiting queue to end of lift queue
            } else {
                liftQueue.add(0);
            }
            
            if(((int)(Math.random()*100)+1) <= DELAY_PROBABILITY){                                  //if 0.05 chance is met, wait up to 8000 milliseconds
                int delay = (int)(Math.random()*8000) + 1;
                MyJPanel.insertText("Lift stops temporarily (for " + delay + " milliseconds).\n");      //display stop message
                try{
                    Thread.sleep(delay);
                } catch(InterruptedException e){
                    e.printStackTrace();
                }
                
                MyJPanel.insertText("Lift continues operation.\n");
            }
            
        }
        	
      }
        
    }
    
	public static void changeActive(boolean newState){
    	active = newState;
    }
	
    public static void addSkier(int ID){
        waitingQueue.add(ID);                                                     // for adding to the waiting queue outside of the class
    }
    
    public static int countLiftQueue(){
        int population = 0;
        for (Integer element : liftQueue) {
            if(element != 0)
                population++;
        }
        return population;

	}
    

}
