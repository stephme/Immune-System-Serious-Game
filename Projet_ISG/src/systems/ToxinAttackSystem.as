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
	import components.SpecialisationLevel;
	/**
	 * ...
	 * @author Stéphane
	 */
	public class ToxinAttackSystem extends System {
		
		private var movingEntities:Family;
		private var targetMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			//toxinEntities = entityManager.getFamily(allOfGenes(TextureRessource,));
			lynphoBEntities = entityManager.getFamily(allOfGenes(SpecialisationLevel));
			cellEntities = entityManager.getFamily(noneOfGenes(TargetPos));
			//lynphoT8Entities = 
			
			// Définition des mappers
			transformMapper = geneManager.getComponentMapper(Transform);
			targetMapper = geneManager.getComponentMapper(TargetPos);
			textureResourceMapper = geneManager.getComponentMapper(TextureResource);
		}
		
		override protected function onProcess(delta:Number):void {
			
		}
		
	}

}