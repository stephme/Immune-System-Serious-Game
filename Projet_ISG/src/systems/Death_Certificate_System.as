package systems 
{
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.game.component.Node;
	import com.ktm.genome.render.component.Layer;
	
	import components.Death_Certificate;
	import com.ktm.genome.render.component.Transform;
	
	public class Death_Certificate_System extends System {
		
		public static const FEW_WASTES:int = 3;
		public static const MANY_WASTES:int = 6;
		
		private var _Dead_Entities:Family;
		private var _Death_Certificate_Mapper:IComponentMapper;
		private var _Transform_Mapper:IComponentMapper;
		private var layerMapper:IComponentMapper;
		
		override protected function onConstructed() : void {
			super.onConstructed();
			_Dead_Entities = entityManager.getFamily(allOfGenes(Death_Certificate));

			_Death_Certificate_Mapper = geneManager.getComponentMapper(Death_Certificate);
			_Transform_Mapper = geneManager.getComponentMapper(Transform);
			layerMapper = geneManager.getComponentMapper(Layer);
		}
		
		override protected function onProcess(delta:Number):void {
			var familySize:Number = _Dead_Entities.members.length; 
			var j:int;
			for (var i:int = 0 ; i < familySize ; i++) {
				var e:IEntity = _Dead_Entities.members[i];
				var deathCerti:Death_Certificate = _Death_Certificate_Mapper.getComponent(e);
				var trans:Transform = _Transform_Mapper.getComponent(e);
				
				if (deathCerti.dead && deathCerti.active) {
					deathCerti.active = false;
					
					var ve:Virus_Field = new Virus_Field();
					ve.transform = { x : trans.x, y : trans.y };
					ve.type = { propagation : Math.random()+0.1, effectiveness : 1 + (int)(3 * Math.random()) };
					ve.targetPos = { x: trans.x, y : trans.y };
					
					var l:Layer = layerMapper.getComponent(e);
					if (l.id == "bacteriaLayer")
						deathCerti.wasted = FEW_WASTES;
					else
						deathCerti.wasted = MANY_WASTES;
					
					for (j = 0; j < int(deathCerti.infected); j++)
						EntityFactory.createVirusEntity(entityManager, ve);
					for (j = 0; j < deathCerti.wasted; j++)
						EntityFactory.createWasteEntity(entityManager, ve.transform.x, ve.transform.y);
						
					if (UserMovingSystem.entitySelected == e)
						UserMovingSystem.entitySelected = null;
					
					EntityFactory.killEntity(entityManager, e, trans);
					
					trace("entity is dead");
					trace("number of virus generated : " + int(deathCerti.infected));
					trace("number of wastes generated : " + deathCerti.wasted);
				}
			}
		}
	}

}