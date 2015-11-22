package systems {
	import com.ktm.genome.core.logic.system.System;
	
	public class T8AttackSystem extends System {
		private var macrophageFamily:Family;
		private var transformMapper:IComponentMapper;
		private var healthMapper:IComponentMapper;
		private var deathCertificateMapper:IComponentMapper;
		private var aggluMapper:IComponentMapper;
		private var virusTypeVMapper:IComponentMapper;
		private var macroStateMapper:IComponentMapper;
		private var bactoriaMapper:IComponentMapper;

		override protected function onConstructed():void {
			macrophageFamily = entityManager.getFamily(allOfGenes(MacrophageState));
			
			victimFamilies = new Vector.<Family>;
			victimFamilies.push(entityManager.getFamily(allOfGenes(ToxinProductionSystem)));
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.CELL)));
			
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

		}
	}
}