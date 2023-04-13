@isTest
public class UnitServiceTest {

   @isTest 
    private static void firstTestMethod(){
        
        User testUser = [select Id from User where Id = :UserInfo.getUserId()];
        
        Modulo__c module = new Modulo__c(
            Name = 'PrimerModuloTest',
            Rol__c = 'Admin',
            Skill__c = 'Apex'
        );
        insert module;
        
        Unidad__c unit = new Unidad__c(
        	Modulo__c = module.id,
            Puntos__c = 100,
            Contenido__c = 'First unit content',
            Tiempo_Estimado__c = 20
        );
        insert unit;
        
        Pregunta__c question = new Pregunta__c(
            Unidad__c = unit.id,
            Contenido__c = 'Question description, the real question'
        );
        insert question;
        
        Respuesta__c option = new Respuesta__c(
            Pregunta__c = question.id,
            Contenido_Respuesta__c = 'Option descrition, the real option',
            Es_Correcta__c = 'Si'
        );
        insert option;
        
        User_Respuesta__c questionResponse = new User_Respuesta__c(
            Pregunta__c = question.id,
            Respuesta__c = option.id
        );
        insert questionResponse;

        
        Map<Id, Id> jsonAnswers = new Map<Id, Id>();
        jsonAnswers.put(question.id, option.id);
        
        Object testAnswers = jsonAnswers;
        
        test.startTest();
        Boolean result = UnitService.saveAnswers(unit.Id, testAnswers);
        test.stopTest(); 
        
        System.assertEquals(true, result);
        List<User_Unidad__c> unitResponses = [SELECT Id, Estados__c FROM User_Unidad__c WHERE Unidad__c = :unit.Id];
        System.assertEquals(1, unitResponses.size());
        System.assertEquals('Success', unitResponses[0].Estados__c);
        
        List<User_Respuesta__c> questionResponses = [SELECT Id, Pregunta__c, Respuesta__c FROM User_Respuesta__c WHERE User_Unidad__c = :unitResponses[0].Id];
        System.assertEquals(1, questionResponses.size());
        System.assertEquals(question.Id, questionResponses[0].Pregunta__c);
        System.assertEquals(option.Id, questionResponses[0].Respuesta__c);
        
        
    }
    
        @isTest
    private static void secondTestMethod(){
        
        User testUser = [select Id from User where Id = :UserInfo.getUserId()];
        
        Modulo__c module = new Modulo__c(
            Name = 'PrimerModuloTest',
            Rol__c = 'Admin',
            Skill__c = 'Apex'
        );
        insert module;
        
        Unidad__c unit = new Unidad__c(
            Modulo__c = module.id,
            Puntos__c = 100,
            Contenido__c = 'First unit content',
            Tiempo_Estimado__c = 20
        );
        insert unit;
        
        Pregunta__c question = new Pregunta__c(
            Unidad__c = unit.id,
            Contenido__c = 'Question description, the real question'
        );
        insert question;
        
        Respuesta__c option = new Respuesta__c(
            Pregunta__c = question.id,
            Contenido_Respuesta__c = 'Option descrition, the real option',
            Es_Correcta__c = 'Si'
        );
        insert option;
        
        User_Modulo__c moduleResponse = new User_Modulo__c(
            Modulo__c = module.id,
            User__c = testUser.id
        );
        insert moduleResponse;        
        
        
        Map<Id, Id> jsonAnswers = new Map<Id, Id>();
        jsonAnswers.put(question.id, option.id);
        
        Object testAnswers = jsonAnswers;
        
        test.startTest();
        Boolean result = UnitService.saveAnswers(unit.Id, testAnswers);
        test.stopTest();
        
        System.assertEquals(true, result);
        List<User_Unidad__c> unitResponses = [SELECT Id, Estados__c FROM User_Unidad__c];
        System.assertEquals(1, unitResponses.size());
        System.assertEquals('Success', unitResponses[0].Estados__c);
        
        List<User_Respuesta__c> questionResponses = [SELECT Id, Pregunta__c, Respuesta__c FROM User_Respuesta__c WHERE User_Unidad__c = :unitResponses[0].Id];
        System.assertEquals(1, questionResponses.size());
        System.assertEquals(question.Id, questionResponses[0].Pregunta__c);
        System.assertEquals(option.Id, questionResponses[0].Respuesta__c);
    }
    
    @isTest
    private static void thirdTestMethod(){
        
        User testUser = [select Id from User where Id = :UserInfo.getUserId()];
        
        Modulo__c module = new Modulo__c(
            Name = 'PrimerModuloTest',
            Rol__c = 'Admin',
            Skill__c = 'Apex'
        );
        insert module;
        
        Unidad__c unit = new Unidad__c(
            Modulo__c = module.id,
            Puntos__c = 100,
            Contenido__c = 'First unit content',
            Tiempo_Estimado__c = 20
        );
        insert unit;
        
        Pregunta__c question = new Pregunta__c(
            Unidad__c = unit.id,
            Contenido__c = 'Question description, the real question'
        );
        insert question;
        
        Respuesta__c option = new Respuesta__c(
            Pregunta__c = question.id,
            Contenido_Respuesta__c = 'Option descrition, the real option',
            Es_Correcta__c = 'Si'
        );
        insert option;
        
        Respuesta__c wrongOption = new Respuesta__c(
            Pregunta__c = question.id,
            Contenido_Respuesta__c  = 'Option descrition, the real incorrect option',
            Es_Correcta__c = 'No'
        );
        insert wrongOption;
        
        User_Modulo__c moduleResponse = new User_Modulo__c(
            Modulo__c = module.id,
            User__c = testUser.id
        );
        insert moduleResponse;
        
        User_Respuesta__c questionResponse = new User_Respuesta__c(
            Pregunta__c = question.id,
            Respuesta__c = wrongOption.id
        );
        insert questionResponse;
        
        
        Map<Id, Id> jsonAnswers = new Map<Id, Id>();
        jsonAnswers.put(question.id, wrongOption.id);
        
        Object testAnswers = jsonAnswers;
        
        test.startTest();
        Boolean result = UnitService.saveAnswers(unit.Id, testAnswers);
        test.stopTest();
        
        System.assertEquals(true, result);
        List<User_Unidad__c> unitResponses = [SELECT Id, Estados__c FROM User_Unidad__c];
        System.assertEquals(1, unitResponses.size());
        System.assertEquals('Fail', unitResponses[0].Estados__c);
        
        List<User_Respuesta__c> questionResponses = [SELECT Id, Pregunta__c, Respuesta__c FROM User_Respuesta__c WHERE User_Unidad__c = :unitResponses[0].Id];
        System.assertEquals(1, questionResponses.size());
        System.assertEquals(question.Id, questionResponses[0].Pregunta__c);
        System.assertEquals(wrongOption.Id, questionResponses[0].Respuesta__c);
    }
    
    @isTest
    private static void wrapperTestMethod(){
        User testUser = [select Id from User where Id = :UserInfo.getUserId()];
        
        Trail__c trail = new Trail__c(
            Name = 'Primer trail',
            Detalle__c = 'Una desc'
        );
        insert trail;
        
        User_Trail__c trailProgress = new User_Trail__c(
            User__c = testUser.Id,
            Trail__c = trail.id
        );
        insert trailProgress;
        
        Modulo__c module = new Modulo__c(
            Name = 'PrimerModuloTest',
            Rol__c = 'Admin',
            Skill__c = 'Apex',
            Active__c = true
        );
        insert module;
        
        Trail_Modulo__c trailModule = new Trail_Modulo__c(
            Trail__c = trail.id,
            Modulo__c = module.id
        );
        insert trailModule;
        
        Unidad__c unit = new Unidad__c(
            Modulo__c = module.id,
            Puntos__c = 100,
            Contenido__c = 'First unit content',
            Tiempo_Estimado__c = 20
        );
        insert unit;
        
        Pregunta__c question = new Pregunta__c(
            Unidad__c = unit.id,
            Contenido__c = 'Question description, the real question'
        );
        insert question;
        
        Respuesta__c option = new Respuesta__c(
            Pregunta__c = question.id,
            Contenido_Respuesta__c = 'Option descrition, the real option',
            Es_Correcta__c = 'Si'
        );
        insert option;
        
        User_Modulo__c moduleResponse = new User_Modulo__c(
            Modulo__c = module.id,
            User__c = testUser.id,
            Estado__c = 'Completado'
        );
        insert moduleResponse;
        
        User_Unidad__c unitResponse = new User_Unidad__c(
            User_Modulo__c = moduleResponse.id,
            Unidad__c = unit.id,
            Estados__c = 'Success'
        );
        insert unitResponse;
        
        Test.startTest();
        UnitService.TrailWrapper tw = UnitService.getTrailWrapper(trail.id);
        UnitService.UnitWrapper uw = UnitService.getUnitWrapper(unit.Id);
        Test.stopTest();
        
        System.assert(tw != null);
        System.assertEquals('Primer trail', tw.trail.Name);
        System.assert(uw != null);
        
    }
    
        
}