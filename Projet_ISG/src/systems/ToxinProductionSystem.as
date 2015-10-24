package systems 
{
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.game.component.Node;
	import com.ktm.genome.render.component.Transform;
	import com.lip6.genome.geography.move.component.TargetPos;
	import components.ToxinProduction;
	/**
	 * ...
	 * @author Stéphane
	 */
	public class ToxinProductionSystem extends System {
		
		private var bacteriaEntities:Family;
		private var transformMapper:IComponentMapper;
		private var toxinProductionMapper:IComponentMapper;
		private var nodeMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			bacteriaEntities = entityManager.getFamily(allOfGenes(ToxinProduction));
			
			// Définition des mappers
			toxinProductionMapper = geneManager.getComponentMapper(ToxinProduction);
			transformMapper = geneManager.getComponentMapper(Transform);
			nodeMapper = geneManager.getComponentMapper(Node);
		}
		
		/*
		 * Chaque bactérie génère une toxine toutes les N frames (N étant la valeur de la variable freq du composant ToxinProduction 
		 * de l'entité)	
		 */
		override protected function onProcess(delta:Number):void {
			for (var i:int = 0 ; i < bacteriaEntities.members.length ; i++) {
				var e:IEntity = bacteriaEntities.members[i];
				var tp:ToxinProduction = toxinProductionMapper.getComponent(e);
				if (++tp.cpt == tp.freq) {
					var n:Node = nodeMapper.getComponent(e);
					var tr:Transform = transformMapper.getComponent(n.inNodes[0].entity);
					EntityFactory.createToxinEntity(entityManager, tr.x, tr.y);
					tp.cpt = 0;
				}
			}
		}
		
	}

}