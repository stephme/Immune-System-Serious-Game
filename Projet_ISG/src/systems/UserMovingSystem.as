package systems 
{
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfFlags;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.resource.component.TextureResource;
	import com.lip6.genome.geography.move.component.TargetPos;
	import components.SpecialisationLevel;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Stéphane
	 */
	public class UserMovingSystem extends System {
		
		private var stage:Stage;
		private var families:Vector.<Family>;
		private var transformMapper:IComponentMapper;
		private var targetPosMapper:IComponentMapper;
		
		private var entitySelected:IEntity;
		
		public function UserMovingSystem(stage:Stage):void {
			this.stage = stage;
		}
		
		override protected function onConstructed():void {
			if (stage) {
				stage.addEventListener(MouseEvent.CLICK, selectEntity);
				stage.addEventListener(MouseEvent.RIGHT_CLICK, moveEntity);
				
				families = new Vector.<Family>();
				families.push(entityManager.getFamily(allOfFlags(Flag.LYMPHO_T8)));
				families.push(entityManager.getFamily(allOfFlags(Flag.MACRO)));
				families.push(entityManager.getFamily(allOfGenes(SpecialisationLevel)));
				
				transformMapper = geneManager.getComponentMapper(Transform);
				targetPosMapper = geneManager.getComponentMapper(TargetPos);
				
				entitySelected = null;
			}
		}
		
		private function selectEntity(e:MouseEvent):void {
			for (var i:int = 0; i < families.length; i++) {
				for (var j:int = 0; j < families[i].members.length; j++) {
					var en:IEntity = families[i].members[j];
					var tr:Transform = transformMapper.getComponent(en);
					if (Math.sqrt(Math.pow(tr.x - e.localX, 2) + Math.pow(tr.y - e.localY, 2)) <= 50) {
						if (entitySelected != en) {
							entitySelected = en;
							trace("selected");
						} else
							trace("already selected");
						return;
					}
				}
			}
			if (entitySelected != null) {
				entitySelected = null;
				trace("end selection");
			}
		}
		
		private function moveEntity(e:MouseEvent):void {
			if (entitySelected != null) {
				trace("moving entity");
				var tp:TargetPos = targetPosMapper.getComponent(entitySelected);
				tp.x = e.localX;
				tp.y = e.localY;
			}
		}
		
	}

}