package systems {
	import com.ktm.genome.core.data.component.Component;
	import com.ktm.genome.core.data.component.IComponent;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfFlags;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.game.component.Node;
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.resource.component.TextureResource;
	import com.lip6.genome.geography.move.component.Speed;
	import components.Health;
	import components.MacrophageState;
	import components.VirusTypeV;
	import components.ToxinProduction;
	import components.DeathCertificate;
	import components.Agglutined;
	import com.ktm.genome.core.entity.IEntity;
	
	public class MacrophageAttackSystem extends System {
		private var victimFamilies:Vector.<Family>;
		private var macrophageFamily:Family;
		private var transformMapper:IComponentMapper;
		private var deathCertificateMapper:IComponentMapper;
		private var aggluMapper:IComponentMapper;
		private var virusTypeVMapper:IComponentMapper;
		private var toxinProductionMapper:IComponentMapper;
		private var healthMapper:IComponentMapper;
		private var macroStateMapper:IComponentMapper;
		private var nodeMapper:IComponentMapper;
		
		//A ENLEVER
		private var textureResourceMapper:IComponentMapper;
		private var speedMapper:IComponentMapper;

		override protected function onConstructed():void {
			macrophageFamily = entityManager.getFamily(allOfGenes(MacrophageState));
			
			victimFamilies = new Vector.<Family>;
			victimFamilies.push(entityManager.getFamily(allOfGenes(VirusTypeV))); //virus
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.TOXIN))); //toxine
			victimFamilies.push(entityManager.getFamily(allOfGenes(ToxinProduction))); //bacterie
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.WASTE))); //dechet
			
			deathCertificateMapper = geneManager.getComponentMapper(DeathCertificate);
			aggluMapper = geneManager.getComponentMapper(Agglutined);
			virusTypeVMapper = geneManager.getComponentMapper(VirusTypeV);
			transformMapper = geneManager.getComponentMapper(Transform);
			toxinProductionMapper = geneManager.getComponentMapper(ToxinProduction);
			healthMapper = geneManager.getComponentMapper(Health);
			nodeMapper = geneManager.getComponentMapper(Node);
			macroStateMapper = geneManager.getComponentMapper(MacrophageState);
			
			//A ENLEVER
			textureResourceMapper = geneManager.getComponentMapper(TextureResource);
			speedMapper = geneManager.getComponentMapper(Speed);
		}
		
		override protected function onProcess(delta:Number):void {
			var victimsVector:Vector.<IEntity> = new Vector.<IEntity>;
			for (var j:int = 0; j <  victimFamilies.length;  ++j)
				victimsVector = victimsVector.concat(victimFamilies[j].members);
			for (var m:int = 0; m < macrophageFamily.members.length; ++m) {
				var macro:IEntity = macrophageFamily.members[m];
				if (deathCertificateMapper.getComponent(macro).dead) continue;
				var macroTr:Transform = transformMapper.getComponent(macro);
				var macroMs:MacrophageState = macroStateMapper.getComponent(macro);
				var macroHealth:Health = healthMapper.getComponent(macro);
				for (var i:int = 0; i < victimsVector.length; i++) {
					var victim:IEntity = victimsVector[i];
					var victimDc:DeathCertificate = deathCertificateMapper.getComponent(victim);
					if (victimDc.dead) continue;
					var virusTypeV:VirusTypeV = virusTypeVMapper.getComponent(victim);
					if (virusTypeV != null && !aggluMapper.getComponent(victim).agglu) continue;
					var victimTr:Transform =  transformMapper.getComponent(victim);
					var victimTp:ToxinProduction = toxinProductionMapper.getComponent(victim);
					if ((virusTypeV != null && Contact.virusContact(macroTr, victimTr, 25)) || 
						(victim.flags == Flag.WASTE && Contact.wasteContact(macroTr, victimTr)) ||
						(victim.flags == Flag.TOXIN && Contact.toxinContact(victimTr, macroTr)) ||
						(victimTp != null && Contact.bacteryContact(macroTr, victimTr, transformMapper.getComponent(nodeMapper.getComponent(victim).outNodes[1].entity), 25))) {
						victimDc.dead = true;
						if (victimTp != null)
							victimDc.infected = -1;
						macroHealth.currentPV -= macroMs.eatingDamages;
						HealthSystem.updateHealthBar(transformMapper.getComponent(nodeMapper.getComponent(macro).outNodes[0].entity), macroHealth);
					}
				}
			}
		}
		
	}
}