package systems {
	import com.ktm.genome.core.entity.family.matcher.allOfFlags;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.core.data.component.Component;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.render.component.Transform;
	import components.VirusTypeA;
	import components.ToxinDamages;
	import components.ToxinProduction;
	import components.DeathCertificate;
	import components.MacrophageState;
	import components.SpecialisationLevel;
	
	public class T8AttackSystem extends System {
		private var t8Family:Family;
		private var victimFamilies:Vector.<Family>;
		private var transformMapper:IComponentMapper;
		private var deathCertificateMapper:IComponentMapper;
		private var virusTypeAMapper:IComponentMapper;

		override protected function onConstructed():void {
			t8Family = entityManager.getFamily(allOfFlags(Flag.LYMPHO_T8));
			
			victimFamilies = new Vector.<Family>;
			victimFamilies.push(entityManager.getFamily(allOfGenes(ToxinProduction)));
			victimFamilies.push(entityManager.getFamily(allOfGenes(MacrophageState)));
			victimFamilies.push(entityManager.getFamily(allOfGenes(SpecialisationLevel)));
			victimFamilies.push(entityManager.getFamily(allOfGenes(MacrophageState)));
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.CELL)));
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.LYMPHO_T8)));
			
			deathCertificateMapper = geneManager.getComponentMapper(DeathCertificate);
			virusTypeAMapper = geneManager.getComponentMapper(VirusTypeA);
			transformMapper = geneManager.getComponentMapper(Transform);
		}
		
		override protected function onProcess(delta:Number):void {
			var victimsVector:Vector.<IEntity> = new Vector.<IEntity>;
			for (var j:int = 0; j <  victimFamilies.length;  ++j)
				victimsVector = victimsVector.concat(victimFamilies[j].members);
			for (var m:int = 0; m < t8Family.members.length; ++m) {
				var t8:IEntity = t8Family.members[m];
				var t8Tr:Transform = transformMapper.getComponent(t8);
				if (deathCertificateMapper.getComponent(t8).dead) continue;
				for (var i:int = 0; i < victimsVector.length; i++) {
					var victim:IEntity = victimsVector[i];
					if (deathCertificateMapper.getComponent(victim).dead || virusTypeAMapper.getComponent(victim) == null) continue;
					if (Contact.virusContact(t8Tr, transformMapper.getComponent(victim), 25)) {
						deathCertificateMapper.getComponent(victim).dead = true;
						deathCertificateMapper.getComponent(victim).wasted = -1;
						deathCertificateMapper.getComponent(victim).infected = -1;
					}
				}
			}
		}
	}
}