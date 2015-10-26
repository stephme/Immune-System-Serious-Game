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
	import components.Tag;
	/**
	 * ...
	 * @author Stéphane
	 */
	public class ToxinAttackSystem extends System {
		
		public static const TOXIN_DAMAGES:Number = 5;
		
		private var toxinEntities:Family;
		private var victimFamilies:Vector.<Family>;
		private var transformMapper:IComponentMapper;
		private var healthMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			toxinEntities = entityManager.getFamily(allOfFlags(Flag.TOXIN));
			
			victimFamilies = new Vector.<Family>;
			victimFamilies.push(entityManager.getFamily(allOfFlags(Flag.LYMPHO_T8))); //lympho T8
			victimFamilies.push(entityManager.getFamily(allOfGenes(SpecialisationLevel))); //lympho B
			victimFamilies.push(entityManager.getFamily(noneOfGenes(TargetPos))); // cell
			
			// Définition des mappers
			transformMapper = geneManager.getComponentMapper(Transform);
			healthMapper = geneManager.getComponentMapper(Health);
		}
		
		override protected function onProcess(delta:Number):void {
			for (var i:int; i < toxinEntities.members.length; i++) {
				var e:IEntity = toxinEntities.members[i];
				var ttr:Transform = transformMapper.getComponent(e);
				//Parcours des lymphocytesT8
				for (var j:int; j < victimFamilies.length; j++) {
					for (var h:int; h < victimFamilies[j].members.length; h++) {
						var v:IEntity = victimFamilies[j].members[h];
						var vtr:Transform = transformMapper.getComponent(v);
						
						//A changer pour une fonction qui renvoit vrai si les deux entites s'intersectent
						if (vtr.x == ttr.x && vtr.y == ttr.y) {
							var h:Health = healthMapper.getComponent(v);
							h.currentPV -= TOXIN_DAMAGES;
						}
					}
				}
			}
		}
		
	}

}