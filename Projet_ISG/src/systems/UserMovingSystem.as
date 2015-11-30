package systems 
{
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfFlags;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.game.component.INode;
	import com.ktm.genome.game.component.Node;
	import com.ktm.genome.render.component.Layer;
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.resource.component.TextureResource;
	import com.lip6.genome.geography.move.component.TargetPos;
	import components.MacrophageState;
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
		private var nodeMapper:IComponentMapper;
		private var layerMapper:IComponentMapper;
		
		public static var entitySelected:IEntity;
		
		public function UserMovingSystem(stage:Stage):void {
			this.stage = stage;
		}
		
		override protected function onConstructed():void {
			if (stage != null) {
				stage.addEventListener(MouseEvent.CLICK, selectEntity);
				stage.addEventListener(MouseEvent.RIGHT_CLICK, moveEntity);
				
				families = new Vector.<Family>();
				families.push(entityManager.getFamily(allOfFlags(Flag.LYMPHO_T8))); //lymphoT8
				families.push(entityManager.getFamily(allOfGenes(MacrophageState))); //Macrophage
				families.push(entityManager.getFamily(allOfGenes(SpecialisationLevel))); //lymphoB
				
				transformMapper = geneManager.getComponentMapper(Transform);
				targetPosMapper = geneManager.getComponentMapper(TargetPos);
				nodeMapper = geneManager.getComponentMapper(Node);
				layerMapper = geneManager.getComponentMapper(Layer);
				
				entitySelected = null;
			}
		}
		
		private function selectEntity(e:MouseEvent):void {
			for (var i:int = 0; i < families.length; i++) {
				for (var j:int = 0; j < families[i].members.length; j++) {
					var en:IEntity = families[i].members[j];
					var tr:Transform = transformMapper.getComponent(en);
					if (Math.sqrt(Math.pow(tr.x - e.localX, 2) + Math.pow(tr.y - e.localY, 2)) <= 25) {
						if (entitySelected != en) {
							if (entitySelected != null)
								endSelection();
							entitySelected = en;
							//Ajout de l'entité pour le cercle de selection
							var n:Node = nodeMapper.getComponent(en);
							var l:Layer = layerMapper.getComponent(en);
							var _tr:Transform = transformMapper.getComponent(n.outNodes[1].entity);
							var c:IEntity = EntityFactory.createSelectionCircleEntity(entityManager, l.id, _tr.x, _tr.y);
							n.outNodes.push(nodeMapper.getComponent(c));
							trace("selected");
						} else {
							trace("already selected");
						}
						return;
					}
				}
			}
			if (entitySelected != null)
				endSelection();
		}
		
		private function moveEntity(e:MouseEvent):void {
			if (entitySelected != null) {
				var tp:TargetPos = targetPosMapper.getComponent(entitySelected);
				tp.x = e.localX;
				tp.y = e.localY;
			}
		}
		
		private function endSelection():void {
			trace("end selection");
			var n:INode = nodeMapper.getComponent(entitySelected).outNodes.pop();
			entityManager.killEntity(n.entity);
			entitySelected = null;
		}
		
	}

}