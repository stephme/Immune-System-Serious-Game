package systems 
{
	import com.ktm.genome.core.data.component.IComponent;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.game.component.Node;
	import com.ktm.genome.render.component.Layered;
	import com.ktm.genome.resource.component.TextureResource;
	import com.ktm.genome.render.component.Transform;
	import components.VirusTypeA;
	import components.ToxinProduction;
	import components.DeathCertificate;
	
	public class DeathCertificateSystem extends System {
		
		public static const FEW_WASTES:int = 3;
		public static const MANY_WASTES:int = 6;
		
		private var _Dead_Entities:Family;
		private var _Death_Certificate_Mapper:IComponentMapper;
		private var _Transform_Mapper:IComponentMapper;
		private var _VirusTypeA_Mapper:IComponentMapper;
		private var _Node_Mapper:IComponentMapper;
		private var _ToxinProduction_Mapper:IComponentMapper;
		private var _TextureResource_Mapper:IComponentMapper;
		
		override protected function onConstructed() : void {
			super.onConstructed();
			_Dead_Entities = entityManager.getFamily(allOfGenes(DeathCertificate));

			_Death_Certificate_Mapper = geneManager.getComponentMapper(DeathCertificate);
			_Transform_Mapper = geneManager.getComponentMapper(Transform);
			_VirusTypeA_Mapper = geneManager.getComponentMapper(VirusTypeA);
			_Node_Mapper = geneManager.getComponentMapper(Node);
			_ToxinProduction_Mapper = geneManager.getComponentMapper(ToxinProduction);
			_TextureResource_Mapper = geneManager.getComponentMapper(TextureResource);
		}
		
		override protected function onProcess(delta:Number):void {
			var familySize:Number = _Dead_Entities.members.length; 
			var j:int;
			for (var i:int = 0 ; i < familySize ; i++) {
				var victim:IEntity = _Dead_Entities.members[i];
				var victimDc:DeathCertificate = _Death_Certificate_Mapper.getComponent(victim);
				var victimTr:Transform = _Transform_Mapper.getComponent(victim);
				
				if (victimDc.dead) {
					if (_ToxinProduction_Mapper.getComponent(victim) != null)
						victimDc.wasted = FEW_WASTES;
					else if (victimDc.wasted != -1)
						victimDc.wasted = MANY_WASTES;
						
					if (victimDc.infected > 0) {
						var victimVt:VirusTypeA = _VirusTypeA_Mapper.getComponent(victim);
						var ve:Virus_Field = new Virus_Field();
						ve.transform = { x : victimTr.x, y : victimTr.y };
						ve.type = { propagation : victimVt.propagation , effectiveness : victimVt.effectiveness};
						ve.targetPos = { x: victimTr.x, y : victimTr.y };
						for (j = 0; j < int(victimDc.infected); j++) {
							EntityFactory.createVirusEntity(entityManager, ve);
						}
					}
					
					for (j = 0; j < victimDc.wasted; j++)
						EntityFactory.createWasteEntity(entityManager, victimTr.x, victimTr.y);
					
					if (UserMovingSystem.entitySelected == victim)
						UserMovingSystem.entitySelected = null;
					
					trace("entity is dead");
					trace("number of virus generated : " + int(victimDc.infected));
					trace("number of wastes generated : " + victimDc.wasted);
					
					var obj:Object = { };
					if ((node = _Node_Mapper.getComponent(victim)) != null) {
						obj.x = victimTr.x + _Transform_Mapper.getComponent(node.outNodes[1].entity).x;
						obj.y = victimTr.y + _Transform_Mapper.getComponent(node.outNodes[1].entity).y;
						obj.rotation = _Transform_Mapper.getComponent(node.outNodes[1].entity).rotation;
						obj.source = _TextureResource_Mapper.getComponent(node.outNodes[1].entity).source;
						obj.id = _TextureResource_Mapper.getComponent(node.outNodes[1].entity).id;
					} else {
						obj.x = victimTr.x;
						obj.y = victimTr.y;
						obj.rotation = victimTr.rotation;
						obj.source = _TextureResource_Mapper.getComponent(victim).source;
						obj.id = _TextureResource_Mapper.getComponent(victim).id;
					}
					var ne:IEntity = EntityFactory.createPlaceHolderEntity(entityManager, obj);
					obj = null;
					EntityFactory.killEntity(entityManager, ne, _Transform_Mapper.getComponent(ne));
					var node:Node = _Node_Mapper.getComponent(victim); 
					if (node != null) {
						for (var n:int = 0; n < node.outNodes.length; n++) {
							var _e:IEntity = node.outNodes[n].entity;
							entityManager.killEntity(_e);
						}
					}
					entityManager.killEntity(victim);
				}
			}
		}
	}

}