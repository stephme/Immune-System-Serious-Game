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
	import components.DeathCertificate;
	import components.Health;
	import components.SpecialisationLevel;
	import components.ToxinProduction;
	import components.VirusTypeA;
	import components.VirusTypeV;
	/**
	 * ...
	 * @author Stéphane
	 */
	public class VirusInfectionSystem extends System {
		
		private var virusEntities:Family;
		private var victimFamilies:Vector.<Family>;
		private var transformMapper:IComponentMapper;
		private var virusTypeVMapper:IComponentMapper;
		private var virusTypeAMapper:IComponentMapper;
		private var healthMapper:IComponentMapper;
		private var deathCertificateMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			virusEntities = entityManager.getFamily(allOfGenes(VirusTypeV));
			
/*			victimFamilies = new Vector.<Family>;
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.LYMPHO_T8))); //lympho T8
			victimFamilies.push(entityManager.getFamily(allOfGenes(SpecialisationLevel))); //lympho B
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.CELL))); // cell
			victimFamilies.push(entityManager.getFamily(allOfGenes(ToxinProduction))); // bactery
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.MACRO))); // macrophage
			*/

			victimsVector = new Vector.<IEntity>;
			victimsVector.concat(
				entityManager.getFamily(allOfFlags(Flag.LYMPHO_T8)).members,
				entityManager.getFamily(allOfGenes(SpecialisationLevel)).members,
				entityManager.getFamily(allOfFlags(Flag.CELL)).members,
				entityManager.getFamily(allOfGenes(ToxinProduction)).members,
				entityManager.getFamily(allOfFlags(Flag.MACRO)).members
			); // macrophage

			transformMapper = geneManager.getComponentMapper(Transform);
			virusTypeVMapper = geneManager.getComponentMapper(VirusTypeV);
			virusTypeAMapper = geneManager.getComponentMapper(VirusTypeA);
			healthMapper = geneManager.getComponentMapper(Health);
			deathCertificateMapper = geneManager.getComponentMapper(DeathCertificate);
		}
			
		override protected function onProcess(delta:Number):void {
			for (var j:int = 0; j < victimsVector.members.length; j++) {
				var victim:IEntity = victimsVector;
				if (victim == null) continue;
				var victimDc:DeathCertificate = DeathCertificateMapper.getComponent(victim);
				var victimVt:VirusTypeA = virusTypeAMapper.getComponent(victim);
				if (victimDc.dead || victimVt != null) continue;
				var victimTr:Transform = transformMapper.getComponent(victim);
				var victimH:Health = healthMapper.getComponent(victim);
				for (var h:int = 0; h < virusEntities.members.length; h++) {
					var virus:IEntity = virusEntities.members[h];
					if (virus == null) continue;
					var virusDc:DeathCertificate = DeathCertificateMapper.getComponent(virus);
					if (virusDc.dead) continue;
					var virusVt:VirusTypeV = virusTypeVMapper.getComponent(virus);
					var virusTr:Transform = transformMapper.getComponent(virus);
					if (Contact.virusContact(victimTr, virusTr, 25)) {
						trace("entity is infected by a virus");
						entityManager.addComponent(victim, VirusTypeA, {
							propagation : virusVt.propagation,
							effectiveness : virusVt.effectiveness
						});
						trace("virus is killed");
						virusDc.dead = true;
					}
				}
			}
		}
		
	}

}