package systems 
{
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfFlags;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.entity.impl.Entity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Transform;
	import components.Health;
	import components.SpecialisationLevel;
	import components.ToxinProduction;
	import components.Virus_Type;
	/**
	 * ...
	 * @author Stéphane
	 */
	public class VirusInfectionSystem extends System {
		
		private var virusEntities:Family;
		private var victimFamilies:Vector.<Family>;
		private var transformMapper:IComponentMapper;
		private var virusTypeMapper:IComponentMapper;
		private var healthMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			virusEntities = entityManager.getFamily(allOfGenes(Virus_Type));
			
			victimFamilies = new Vector.<Family>;
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.LYMPHO_T8))); //lympho T8
			victimFamilies.push(entityManager.getFamily(allOfGenes(SpecialisationLevel))); //lympho B
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.CELL))); // cell
			victimFamilies.push(entityManager.getFamily(allOfGenes(ToxinProduction))); // bactery
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.MACRO))); // macrophage
			
			transformMapper = geneManager.getComponentMapper(Transform);
			virusTypeMapper = geneManager.getComponentMapper(Virus_Type);
			healthMapper = geneManager.getComponentMapper(Health);
		}
			
		override protected function onProcess(delta:Number):void {
			for (var i:int = 0; i < victimFamilies.length; i++) {
				for (var j:int = 0; j < victimFamilies[i].members.length; j++) {
					var victim:IEntity = victimFamilies[i].members[j];
					var victimTr:Transform = transformMapper.getComponent(victim);
					var health:Health = healthMapper.getComponent(victim);
					for (var h:int = 0; h < virusEntities.members.length; h++) {
						var virus:IEntity = virusEntities.members[h];
						var vt:Virus_Type = virusTypeMapper.getComponent(virus);
						var virusTr:Transform = transformMapper.getComponent(virus);
						if (Contact.virusContact(victimTr, virusTr, 25) && vt.effectiveness > 0 && health.lifeDecrement == 0) {
							trace("entity is infected by a virus");
							health.numVirusIncrement = vt.propagation;
							health.lifeDecrement = vt.effectiveness;
							trace("virus is killed");
							vt.effectiveness = 0;
							EntityFactory.killEntity(entityManager, virus, virusTr);
						}
					}
				}
			}
		}
		
	}

}