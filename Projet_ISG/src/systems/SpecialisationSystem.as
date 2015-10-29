package systems 
{
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.logic.system.System;
	import components.SpecialisationLevel;
	/**
	 * ...
	 * @author Stéphane
	 */
	public class SpecialisationSystem extends System {
		
		private var lymphoBEntities:Family;
		private var specialisationLevelMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			lymphoBEntities = entityManager.getFamily(allOfGenes(SpecialisationLevel));
			
			// Définition des mappers
			specialisationLevelMapper = geneManager.getComponentMapper(SpecialisationLevel);
		}
		
		override protected function onProcess(delta:Number):void {
			
		}
		
	}

}