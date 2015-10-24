package systems 
{
	import com.ktm.genome.core.entity.family.matcher.allOfFlags;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.game.component.INode;
	import com.ktm.genome.game.component.Node;
	import com.ktm.genome.render.component.Layer;
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.resource.component.TextureResource;
	import com.lip6.genome.geography.move.component.TargetPos;
	import com.ktm.genome.core.logic.system.System;
	import components.BacteriaInRotation;
	import components.ToxinProduction;
	/**
	 * ...
	 * @author Stéphane
	 */
	public class BacteriaRotationSystem extends System {
		
		private var bacteriaEntities:Family;
		private var nodeMapper:IComponentMapper;
		private var targetPosMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		private var bacteriaInRotationMapper:IComponentMapper;

		override protected function onConstructed():void {
			// Paramétrisation de la famille 
			bacteriaEntities = entityManager.getFamily(allOfGenes(ToxinProduction));
			// Définition des mappers
			nodeMapper = geneManager.getComponentMapper(Node);
			targetPosMapper = geneManager.getComponentMapper(TargetPos);
			transformMapper = geneManager.getComponentMapper(Transform);
			bacteriaInRotationMapper = geneManager.getComponentMapper(BacteriaInRotation);
		}
		
		override protected function onProcess(delta:Number):void {
			for (var i:int = 0 ; i < bacteriaEntities.members.length; i++) {
				var e:IEntity = bacteriaEntities.members[i];
				var br:BacteriaInRotation = bacteriaInRotationMapper.getComponent(e);
				var tre:Transform = transformMapper.getComponent(e);
				var n:Node = nodeMapper.getComponent(e);
				
				var p:INode = n.inNodes[0];
				var trp:Transform = transformMapper.getComponent(p.entity);
				var tar:TargetPos = targetPosMapper.getComponent(p.entity);
				
				var hb:INode = p.outNodes[0];
				var trhb:Transform = transformMapper.getComponent(hb.entity);
				
				if (br == null) {
					entityManager.addComponent(e, BacteriaInRotation, { pas:0.08, leftToRotate:0 } );
				} else if (trp.x == tar.x && trp.y == tar.y) {
					br.leftToRotate = 0;
				} else if (br.leftToRotate != 0) {
					tre.rotation = clampAngle(tre.rotation + br.pas * br.leftToRotate);
					br.leftToRotate -= br.pas * br.leftToRotate;
					
					var a:Number;
					if ((tre.rotation >= 180 && tre.rotation < 360) || (tre.rotation >= -180 && tre.rotation <= 0)) {
						if ((tre.rotation >= 180 && tre.rotation <= 270) || (tre.rotation >= -180 && tre.rotation <= -90))
							a = Math.abs(tre.rotation) - 180;
						else if (tre.rotation >= 270 && tre.rotation < 360)
							a = 360 - tre.rotation;
						else if (tre.rotation >= -90 && tre.rotation <= 0)
							a = tre.rotation;
						var y:Number = Math.sin(Math.abs(a) * (Math.PI / 180)) * 54;
						trhb.y = -y - 25;
					} else {
						trhb.y = -32;
					}
					
					if ((tre.rotation >= 90 && tre.rotation <= 270) || (tre.rotation <= -90 && tre.rotation >= -270)) {
						a = Math.abs(tre.rotation) - 180;
						var x:Number = Math.cos(Math.abs(a) * (Math.PI / 180)) * 54;
						trhb.x = -x;
					} else {
						trhb.x = 0;
					}
					
				} else {
					var angle:Number = Math.atan2(tar.y - trp.y, tar.x - trp.x);
					angle = (angle / Math.PI) * 180;
					br.leftToRotate = Math.abs(tre.rotation - angle);
					if (tre.rotation >= angle)
						br.leftToRotate *= -1;
				}
			}
		}
		
		public static function clampAngle(angle:Number):Number {
			if (angle >= 360 || angle <= -360)
				return 0;
			return angle;
		}
		
	}

}