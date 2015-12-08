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
	import components.DeathCertificate;
	import components.ToxinProduction;
	import flash.geom.Point;
	import flash.geom.Vector3D;
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
		private var deathCertificateMapper:IComponentMapper;

		override protected function onConstructed():void {
			// Paramétrisation de la famille 
			bacteriaEntities = entityManager.getFamily(allOfGenes(ToxinProduction));
			
			// Définition des mappers
			nodeMapper = geneManager.getComponentMapper(Node);
			targetPosMapper = geneManager.getComponentMapper(TargetPos);
			transformMapper = geneManager.getComponentMapper(Transform);
			bacteriaInRotationMapper = geneManager.getComponentMapper(BacteriaInRotation);
			deathCertificateMapper = geneManager.getComponentMapper(DeathCertificate);
		}
		
		override protected function onProcess(delta:Number):void {
			for (var i:int = 0 ; i < bacteriaEntities.members.length; i++) {
				var e:IEntity = bacteriaEntities.members[i];
				if (deathCertificateMapper.getComponent(e).dead) continue;
				
				var br:BacteriaInRotation = bacteriaInRotationMapper.getComponent(e);
				var trp:Transform = transformMapper.getComponent(e);
				var tar:TargetPos = targetPosMapper.getComponent(e);
				var n:Node = nodeMapper.getComponent(e);
			
				var trhb:Transform = transformMapper.getComponent(n.outNodes[0].entity);
				var tre:Transform = transformMapper.getComponent(n.outNodes[1].entity);
				
				if (trp.x == tar.x && trp.y == tar.y)
					br.leftToRotate = 0;
				else if (br.leftToRotate != 0) {
					tre.rotation = clampAngle(tre.rotation + br.pas * br.leftToRotate);
					br.leftToRotate -= br.pas * br.leftToRotate;
					var p:Point = null;
					if ((tre.rotation > 180 && tre.rotation < 360) || (tre.rotation > -180 && tre.rotation < 0)) {
						p = getExtremityPoint(tre.rotation);
						trhb.y = p.y - 27.5;
					} else
						trhb.y = -27.5;
					
					if ((tre.rotation > 90 && tre.rotation < 270) || (tre.rotation < -90 && tre.rotation > -270)) {
						if (p == null)
							p = getExtremityPoint(tre.rotation);
						trhb.x = p.x;
					} else
						trhb.x = 0;
				} else {
					var angle:Number = Math.atan2(tar.y - trp.y, tar.x - trp.x);
					angle = (angle / Math.PI) * 180;
					br.leftToRotate = angle - tre.rotation;
				}
			}
		}
		
		public static function clampAngle(angle:Number):Number {
			if (angle >= 360 || angle <= -360)
				return 0;
			return angle;
		}
		
		public static function getBacteryPoints(tr:Transform):Vector.<Point> {
			var bacteryPoints:Vector.<Point> = new Vector.<Point>;
			bacteryPoints.push(new Point(tr.x, tr.y));
			var p:Point = getExtremityPoint(tr.rotation);
			bacteryPoints.push(new Point(tr.x + p.x / 2, tr.y + p.y / 2));
			bacteryPoints.push(new Point(tr.x + p.x, tr.y + p.y));
			return bacteryPoints;
		}
		
		public static function getExtremityPoint(rot:Number):Point {
			var a:Number, x:Number, y:Number;
			if ((rot >= 90 && rot <= 270) || (rot <= -90 && rot >= -270)) {
				a = Math.abs(rot) - 180;
				y = Math.sin(Math.abs(a) * (Math.PI / 180)) * 54;
				if ((rot >= 180 && rot <= 270) || (rot <= -90 && rot >= -180))
					y *= -1;
				x = -Math.cos(Math.abs(a) * (Math.PI / 180)) * 54;
			}
			else if ((rot >= 270 && rot < 360) || (rot > -360 && rot <= -270)) {
				a = 360 - Math.abs(rot);
				y = Math.sin(Math.abs(a) * (Math.PI / 180)) * 54;
				if (rot >= 270 && rot < 360)
					y *= -1;
				x = Math.cos(Math.abs(a) * (Math.PI / 180)) * 54;
			}
			else if ((rot >= 0 && rot <= 90) || (rot >= -90 && rot < 0)) {
				a = rot;
				y = Math.sin(Math.abs(a) * (Math.PI / 180)) * 54;
				if (rot >= -90 && rot < 0)
					y *= -1;
				x = Math.cos(Math.abs(a) * (Math.PI / 180)) * 54;
			}
			return new Point(x, y);
		}
		
	}

}