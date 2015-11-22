package systems 
{
	import com.ktm.genome.core.data.component.IComponent;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.game.component.Node;
	import com.ktm.genome.render.component.Layer;
	import components.VirusTypeA;
	
	import components.DeathCertificate;
	import com.ktm.genome.render.component.Transform;
	
	public class DeathCertificateSystem extends System {
		
		public static const FEW_WASTES:int = 3;
		public static const MANY_WASTES:int = 6;
		
		private var _Dead_Entities:Family;
		private var _Death_Certificate_Mapper:IComponentMapper;
		private var _Transform_Mapper:IComponentMapper;
		private var _VirusTypeA_Mapper:IComponentMapper;
		private var layerMapper:IComponentMapper;
		
		override protected function onConstructed() : void {
			super.onConstructed();
			_Dead_Entities = entityManager.getFamily(allOfGenes(DeathCertificate));

			_Death_Certificate_Mapper = geneManager.getComponentMapper(DeathCertificate);
			_Transform_Mapper = geneManager.getComponentMapper(Transform);
			_VirusTypeA_Mapper = geneManager.getComponentMapper(VirusTypeA);
			layerMapper = geneManager.getComponentMapper(Layer);
		}
		
		override protected function onProcess(delta:Number):void {
			var familySize:Number = _Dead_Entities.members.length; 
			var j:int;
			for (var i:int = 0 ; i < familySize ; i++) {
				var e:IEntity = _Dead_Entities.members[i];
				var deathCerti:DeathCertificate = _Death_Certificate_Mapper.getComponent(e);
				var victimTr:Transform = _Transform_Mapper.getComponent(e);
				
				if (deathCerti.dead && deathCerti.active) {
					deathCerti.active = false;					
					var l:Layer = layerMapper.getComponent(e);
					if (l != null && l.id == "bacteriaLayer")
						deathCerti.wasted = FEW_WASTES;
					else if (deathCerti.wasted != -1)
						deathCerti.wasted = MANY_WASTES;
						
					if (deathCerti.infected > 0) {
						var victimVT:VirusTypeA = _VirusTypeA_Mapper.getComponent(e);
						var ve:Virus_Field = new Virus_Field();
						ve.transform = { x : victimTr.x, y : victimTr.y };
						ve.type = { propagation : victimVT.propagation , effectiveness : victimVT.effectiveness};
						ve.targetPos = { x: victimTr.x, y : victimTr.y };
						for (j = 0; j < int(deathCerti.infected); j++) {
							EntityFactory.createVirusEntity(entityManager, ve);
						}
					}
					
					if (deathCerti.wasted > 0) {
						for (j = 0; j < deathCerti.wasted; j++)
							EntityFactory.createWasteEntity(entityManager, victimTr.x, victimTr.y);
					}
					
					if (UserMovingSystem.entitySelected == e)
						UserMovingSystem.entitySelected = null;
					
					EntityFactory.killEntity(entityManager, e, victimTr);
					
					trace("entity is dead");
					trace("number of virus generated : " + int(deathCerti.infected));
					trace("number of wastes generated : " + deathCerti.wasted);
				}
			}
		}
	}

}