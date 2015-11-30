package systems 
{
	
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.noneOfFlags;
	import com.ktm.genome.core.entity.family.matcher.noneOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Transform;
	import com.lip6.genome.geography.move.component.TargetPos;
	import com.ktm.genome.core.logic.system.System;
	import components.MacrophageState;
	import components.SpecialisationLevel;
	 
	public class RandomMovingSystem extends System {
		
		private var movingEntities:Family;
		private var targetMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		
		override protected function onConstructed() :void {
			super.onConstructed();
			// Paramétrisation de la famille 
			movingEntities = entityManager.getFamily(allOfGenes(Transform, TargetPos), noneOfGenes(MacrophageState), noneOfFlags(Flag.LYMPHO_T8), noneOfGenes(SpecialisationLevel));
			// Définition des mappers
			transformMapper = geneManager.getComponentMapper(Transform);
			targetMapper = geneManager.getComponentMapper(TargetPos);
		}
		
		override protected function onProcess(delta:Number):void {
			// Récupérer la taille de la famille (dans notre cas, le nombre d'entités qui
			// contiennent les composants Transform et TargetPos)
			var familySize:int = movingEntities.members.length; 
			// Parcours de la famille
			for (var i:int = 0 ; i < familySize ; i++) {
				// Récupération de la ième entité de la famille
				var e:IEntity = movingEntities.members[i];
				// Récupération des composants Transform et TargetPos contenus dans l’entité e à l’aide des mappers
				var tr:Transform = transformMapper.getComponent(e);
				var target:TargetPos = targetMapper.getComponent(e);
				// Evaluer si la position de l’entité a atteint la cible
				if (target.x == tr.x && target.y == tr.y) {
					// Modification du composant TargetPos
					target.x = Math.random() * 800;
					target.y = Math.random() * 600;
				}
			}
		}
	}

}