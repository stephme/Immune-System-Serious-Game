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
	import com.ktm.genome.resource.component.TextureResource;
	import com.lip6.genome.geography.move.component.TargetPos;
	import com.ktm.genome.core.logic.system.System;
	import components.Health;
	import components.SpecialisationLevel;
	/**
	 * ...
	 * @author Stéphane
	 */
	public class ToxinAttackSystem extends System {
		
		public static const TOXIN_DAMAGES:Number = 0.2;
		
		private var toxinEntities:Family;
		private var victimFamilies:Vector.<Family>;
		private var transformMapper:IComponentMapper;
		private var healthMapper:IComponentMapper;
		private var textureResourceMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			toxinEntities = entityManager.getFamily(allOfFlags(Flag.TOXIN));
			
			victimFamilies = new Vector.<Family>;
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.LYMPHO_T8))); //lympho T8
			victimFamilies.push(entityManager.getFamily(allOfGenes(SpecialisationLevel))); //lympho B
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.CELL))); // cell
			
			// Définition des mappers
			transformMapper = geneManager.getComponentMapper(Transform);
			healthMapper = geneManager.getComponentMapper(Health);
			textureResourceMapper = geneManager.getComponentMapper(TextureResource);
		}
		
		override protected function onProcess(delta:Number):void {
			for (var i:int; i < toxinEntities.members.length; i++) {
				var e:IEntity = toxinEntities.members[i];
				for (var j:int; j < victimFamilies.length; j++) {
					for (var h:int; h < victimFamilies[j].members.length; h++) {
						//trace(j + " : " + victimFamilies[j].members.length);
						var v:IEntity = victimFamilies[j].members[h];
						if (toxinContact(e, v)) {
							var health:Health = healthMapper.getComponent(v);
							health.currentPV -= TOXIN_DAMAGES;
							trace(health.currentPV);
						}
					}
				}
			}
		}
		
		private function toxinContact(e:IEntity, v:IEntity):Boolean {
			var ttr:Transform = transformMapper.getComponent(e);
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
		
	}

}