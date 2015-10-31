package systems
{
	import com.ktm.genome.core.entity.family.matcher.allOfFlags;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.noneOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Layer;
	import com.ktm.genome.render.component.Transform;
	import com.lip6.genome.geography.move.component.TargetPos;
	import com.ktm.genome.core.logic.system.System;
	import components.Health;
	import components.SpecialisationLevel;
	import components.ToxinDamages;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Stéphane
	 */
	public class ToxinAttackSystem extends System {
		
		private var toxinEntities:Family;
		private var victimFamilies:Vector.<Family>;
		private var transformMapper:IComponentMapper;
		private var healthMapper:IComponentMapper;
		private var toxinDamagesMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			toxinEntities = entityManager.getFamily(allOfGenes(ToxinDamages));
			
			victimFamilies = new Vector.<Family>;
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.LYMPHO_T8))); //lympho T8
			victimFamilies.push(entityManager.getFamily(allOfGenes(SpecialisationLevel))); //lympho B
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.CELL))); // cell
			
			// Définition des mappers
			transformMapper = geneManager.getComponentMapper(Transform);
			healthMapper = geneManager.getComponentMapper(Health);
			toxinDamagesMapper = geneManager.getComponentMapper(ToxinDamages);
		}
		
		override protected function onProcess(delta:Number):void {
			for (var i:int = 0; i < victimFamilies.length; i++) {
				for (var j:int = 0; j < victimFamilies[i].members.length; j++) {
					for (var h:int = 0; h < toxinEntities.members.length; h++) {
						var t:IEntity = toxinEntities.members[h];
						var td:ToxinDamages = toxinDamagesMapper.getComponent(t);
						if (td.active) {
							var v:IEntity = victimFamilies[i].members[j];
							if (toxinContact(t, v)) {
								var health:Health = healthMapper.getComponent(v);
								health.currentPV -= ToxinDamages.DAMAGES;
								trace(health.currentPV);
								td.active = false;
								killToxin(t);
							}
						}
					}
				}
			}
		}
		
		private function toxinContact(t:IEntity, v:IEntity):Boolean {
			var ttr:Transform = transformMapper.getComponent(t);
			var vtr:Transform = transformMapper.getComponent(v);
			if (Math.sqrt(Math.pow(ttr.x - vtr.x, 2) + Math.pow(ttr.y - vtr.y, 2)) <= 25)
				return true;
			else if (Math.sqrt(Math.pow((ttr.x+25) - vtr.x, 2) + Math.pow(ttr.y - vtr.y, 2)) <= 25)
				return true;
			else if (Math.sqrt(Math.pow(ttr.x - vtr.x, 2) + Math.pow((ttr.y+16) - vtr.y, 2)) <= 25)
				return true;
			else if (Math.sqrt(Math.pow((ttr.x+25) - vtr.x, 2) + Math.pow((ttr.y+16) - vtr.y, 2)) <= 25)
				return true;
			return false;
		}
		
		private function killToxin(t:IEntity):void {
			var ttr:Transform = transformMapper.getComponent(t);
			var pas:Number = 0.1;
			var tim:Timer = new Timer(100, 1 / pas);
			tim.addEventListener(TimerEvent.TIMER, fadeOut(ttr, pas));
			function fadeOut(ttr:Transform, pas:Number):Function {
				return function():void {
					ttr.alpha -= pas;
				}
			}
			tim.addEventListener(TimerEvent.TIMER_COMPLETE, kill(t));
			function kill(t:IEntity):Function {
				return function():void {
					entityManager.killEntity(t);	
				}
			}
			tim.start();
		}
		
	}

}