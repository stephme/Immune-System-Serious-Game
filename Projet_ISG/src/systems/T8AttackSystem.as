package systems {
	import com.ktm.genome.core.entity.family.matcher.allOfFlags;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.core.data.component.Component;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.game.component.Node;
	import com.ktm.genome.render.component.Transform;
	import components.VirusTypeA;
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
		private var toxinProductionMapper:IComponentMapper;
		private var nodeMapper:IComponentMapper;

		override protected function onConstructed():void {
			t8Family = entityManager.getFamily(allOfFlags(Flag.LYMPHO_T8));
			
			victimFamilies = new Vector.<Family>;
			victimFamilies.push(entityManager.getFamily(allOfGenes(ToxinProduction))); //bacterie
			victimFamilies.push(entityManager.getFamily(allOfGenes(MacrophageState))); //macrophage
			victimFamilies.push(entityManager.getFamily(allOfGenes(SpecialisationLevel))); //lymphoB
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.CELL))); //cell
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.LYMPHO_T8))); //lymphoT8
			
			deathCertificateMapper = geneManager.getComponentMapper(DeathCertificate);
			virusTypeAMapper = geneManager.getComponentMapper(VirusTypeA);
			transformMapper = geneManager.getComponentMapper(Transform);
			toxinProductionMapper = geneManager.getComponentMapper(ToxinProduction);
			nodeMapper = geneManager.getComponentMapper(Node);
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
					var victimDc:DeathCertificate = deathCertificateMapper.getComponent(victim);
					if (victimDc.dead || virusTypeAMapper.getComponent(victim) == null) continue;
					var victimTp:ToxinProduction = toxinProductionMapper.getComponent(victim);
					var victimTr:Transform =  transformMapper.getComponent(victim);
					if ((victimTp != null && Contact.bacteryContact(t8Tr, victimTr, transformMapper.getComponent(nodeMapper.getComponent(victim).outNodes[1].entity), 25)) || (victimTp == null && Contact.entityContact(t8Tr, victimTr))) {
						victimDc.dead = true;
						victimDc.infected = -1;
					}
				}
			}
		}
	}
}