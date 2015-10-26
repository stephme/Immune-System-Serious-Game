package systems 
{
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	
	import components.Death_Certificate;
	import components.Virus_Type;
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.render.component.Layer;
	
	public class Death_Certificate_System extends System {
		private var _Dead_Entities:Family;
		private var _Death_Certificate_Mapper:IComponentMapper;
		private var _Transform_Mapper:IComponentMapper;
		private var _Layer_Mapper:IComponentMapper;
		private var _Virus_Type_Mapper:IComponentMapper;
		
		override protected function OnConstructed() : void {
			super.onConstructed();
			_Dead_Entities = entityManager.getFamily(allOfGenes(Death_Certificate));

			_Death_Certificate_Mapper = geneManager.getComponentMapper(Death_Certificate);
			_Transform_Mapper = geneManager.getComponentMapper(Transform);
			_Layer_Mapper = geneManager.getComponentMapper(Layer);
			_Virus_Type_Mapper = geneManager.getComponentMapper(Virus_Type);
		}
		
		override protected function onProcess(delta:Number):void {
			var familySize:Number = _Dead_Entities.members.length; 

			for (var i:int = 0 ; i < familySize ; i++) {
				var e:IEntity = _Dead_Entities.members[i];
				var deathCerti:Death_Certificate = _Death_Certificate_Mapper.getComponent(e);
				var trans:Transform = _Transform_Mapper.getComponent(e);
				var layer:Layer = _Layer_Mapper.getComponent(e);
				var type:Virus_Type = _Virus_Type_Mapper.getComponent(e);
				
				if (deathCerti.dead) {
					var ve:Virus_Field = new Virus_Field();
					ve.transform = { x : trans.x, y : trans.y };
					ve.type = { propagation : type.propagation, effectiveness : type.effectiveness };
					ve.targetPos = { x: trans.x, y : trans.y };
					
					for (var i:int = 0; i < deathCerti.infected; i++) {
						EntityFactory.createVirusEntity(entityManager, ve);
					}
					
					for (var i:int = 0; i < deathCerti.wasted; i++) {
						EntityFactory.createWasteEntity(entityManager, ve.transform.x, ve.transform.y);
					}
				}
			}
		}
	}

}