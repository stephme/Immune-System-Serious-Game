package systems {
	import com.ktm.genome.core.data.component.Component;
	import com.ktm.genome.core.data.component.IComponent;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.render.component.Transform;
	import components.VirusTypeV;
	import components.ToxinDamages;
	import components.ToxinProduction;
	import components.DeathCertificate;
	import components.Agglutined;
	import components.MacrophageState;
	import com.ktm.genome.core.entity.IEntity;
	
	public class MacrophageAttackSystem extends System {
		private var macrophageFamily:Family;
		private var transformMapper:IComponentMapper;
		private var deathCertificateMapper:IComponentMapper;
		private var aggluMapper:IComponentMapper;
		private var virusTypeVMapper:IComponentMapper;
		private var macroStateMapper:IComponentMapper;
		private var bactoriaMapper:IComponentMapper;

		override protected function onConstructed():void {
			macrophageFamily = entityManager.getFamily(allOfGenes(MacrophageState));
			
			victimFamilies = new Vector.<Family>;
			victimFamilies.push(entityManager.getFamily(allOfGenes(VirusTypeV)));
			victimFamilies.push(entityManager.getFamily(allOfGenes(ToxinDamages)));
			victimFamilies.push(entityManager.getFamily(allOfGenes(ToxinProduction)));
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.WASTE)));
			
			deathCertificateMapper = geneManager.getComponentMapper(DeathCertificate);
			aggluMapper = geneManager.getComponentMapper(Agglutined);
			virusTypeVMapper = geneManager.getComponentMapper(VirusTypeV);
			transformMapper = geneManager.getComponentMapper(Transform);
			macroStateMappe = geneManager.getComponentMapper(MacrophageState);
			bactoriaMapper = geneManager.getComponentMapper(ToxinProduction);
		}
		
		override protected function onProcess(delta:Number):void {
			var victimsVector:Vector.<IEntity> = new Vector.<IEntity>;
			for (var j:int = 0; j <  victimFamilies.length;  ++j)
				victimsVector = victimsVector.concat(victimFamilies[j].members);
			for (var m:int = 0; m < macrophageFamily.members.length; ++m) {
				var macro:IEntity = macrophageFamily.members[m];
				var macroTr:Transform = transformMapper.getComponent(macro);
				var macroMs:MacrophageState = macroStateMapper.getComponent(macro);
				for (var i:int = 0; i < victimsVector.length && macroMs.current < macroMs.hunger; i++) {
					var victim:IEntity = victimsVector[i];
					if (deathCertificateMapper.getComponent(victim).dead) continue;
					if (virusTypeVMapper.getComponent(victim) != null && aggluMapper.getComponent(victim).agglu == false) continue;
					if (Contact.virusContact(macroTr, transformMapper.getComponent(victim), 25)) {
						deathCertificateMapper.getComponent(victim).dead = true;
						if (bactoriaMapper.getComponent(victim) != null) {
							deathCertificateMapper.getComponent(victim).infected = -1;
							deathCertificateMapper.getComponent(victim).wasted = -1;
						}
						macroMs.current++;
					}
				}
				if (macroMs.current == macroMs.hunger) deathCertificateMapper.getComponent(macro).dead = true;
			}
		}
	}
}