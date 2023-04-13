public class UnitResponseService {
    public static void checkResponses(List<User_Unidad__c> unitResponses){
        
        // Lista de Ids de unidades en las UnitsReponses que vienen por parÃ¡metro
        List<Id> unitsId = new List<Id>();
        for(User_Unidad__c u : unitResponses){
            unitsId.add(u.Unidad__c); 
        }
                
        
        // Map of units
        Map<Id, Unidad__c> unitsMap = new Map<Id, Unidad__c>();
        
        List<Unidad__c> units = [SELECT Id, Puntos__c, Name, Tiempo_Estimado__c, Modulo__c, Contenido__c FROM Unidad__c WHERE Id in :unitsId];
        for(Unidad__c u : units){
            unitsMap.put(u.Id, u);
        }
        
        
        // Quereamos las preguntas que estan en estas unidades(units) con su respuesta correctas
        List<Pregunta__c> questions = [SELECT Id, (SELECT Id FROM Respuestas__r WHERE Es_Correcta__c = 'Si')
                                       FROM Pregunta__c
                                       WHERE Unidad__c in :unitsId]; 
        // Mapa de preguntas con sus respuestas correctas.
        // Map<ID = Question__c, ID = Options__c CORRECTA>;
        Map<Id, Id> questionOptionsMap = new Map<Id, Id>();        
               
        // Loop through questions and their related options to populate the map.
        for (Pregunta__c q : questions) {
            questionOptionsMap.put(q.Id, q.Respuestas__r[0].Id);
        }
        
        // Quereamos todas las questionsResponse que vienen dentro de la lista de las unitResponses
        List<User_Respuesta__c> qr = [SELECT Id, Respuesta__c, User_Unidad__c, Pregunta__c
                                        FROM User_Respuesta__c
                                        WHERE User_Unidad__c in :unitResponses];
        
        Map<User_Unidad__c, List<User_Respuesta__c>> UnitWithQuestions = new Map<User_Unidad__c, List<User_Respuesta__c>>();
        for(User_Unidad__c ur : unitResponses){
            List<User_Respuesta__c> listOfResponses = new List<User_Respuesta__c>();
            for(User_Respuesta__c questionResponses : qr){
                if(questionResponses.User_Unidad__c == ur.Id){
                    listOfResponses.add(questionResponses);
                }
            }
            UnitWithQuestions.put(ur, listOfResponses);
        }
        
        for(User_Unidad__c ur : UnitWithQuestions.keySet()){
            List<User_Respuesta__c> responsesToUnit = UnitWithQuestions.get(ur);
            String isUnitCorrect = 'Si';
            for(User_Respuesta__c response : responsesToUnit){
                if(response.Respuesta__c != questionOptionsMap.get(response.Pregunta__c)){
                    isUnitCorrect = 'No';
                }
            }
            if(/*ur.Estados__c =='Answered' &&*/ isUnitCorrect == 'Si'){
                ur.Estados__c = 'Success';
                Integer unitPoints = Integer.valueOf(unitsMap.get(ur.Unidad__c).Puntos__c);
                if(ur.Intentos__c == 1){
                    ur.Puntos__c = unitPoints;
                }else if(ur.Intentos__c == 2){
                    ur.Puntos__c = (unitPoints / 2);
                }else if(ur.Intentos__c > 2){
                    ur.Puntos__c = (unitPoints / 4);
                }
            }else{
                ur.Estados__c = 'Fail';
            }   
             
        }

    }
    
    public static void checkPointsUser(List<User_Unidad__c> unitResponses){
        Set<Id> unitResponsesIds = new Set<Id>();
        for (User_Unidad__c ur : unitResponses){
            unitResponsesIds.add(ur.Id);
        }

        List<User_Unidad__c> urSuccess = [SELECT Id, Puntos__c, User__c, Estados__c FROM User_Unidad__c WHERE Estados__c = 'Success' AND Id in :unitResponsesIds];
        
        Set<Id> userIds = new Set<Id>();
        for (User_Unidad__c us : urSuccess){
            userIds.add(us.User__c);
        }
        
        List<User> users = [SELECT Id, Name, Puntos__c FROM User WHERE Id in :userIds];
        
        for (User_Unidad__c urS : urSuccess){
            for (User Us : users) {
                if (urS.User__c == us.Id){
                    if(Us.Puntos__c == null){
                        Us.Puntos__c = 0;
                    }
                    Us.Puntos__c = Us.Puntos__c + urS.Puntos__c;
                }
            }
        }
        Update users;
              
    }
}